<?php

// Paramètres de connexion à la base de données
$servername = "localhost";
$username   = "root";
$password   = "root";
$dbname     = "European_Soccer";

// Créer la connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Échec de la connexion: " . $conn->connect_error);
}

// Vérifier les paramètres de recherche
$conditions = []; // Stocke les conditions pour la requête SQL

if (!empty($_GET['playerName'])) {
    $playerName = $conn->real_escape_string($_GET['playerName']);
    $conditions[] = "p.`PlayerName` LIKE '%$playerName%'";
}

if (!empty($_GET['age'])) {
    $age = (int)$_GET['age']; // Sécurisation en forçant un entier
    $conditions[] = "p.`Age` = $age";
}

if (!empty($_GET['Affiliation'])) {
  $affiliation = $conn->real_escape_string($_GET['Affiliation']); 
  $conditions[] = "t.`Affiliation` = '$affiliation'"; // Match exact affiliation
}

if (!empty($_GET['League'])) {
  $league= $conn->real_escape_string($_GET['League']); 
  $conditions[] = "l.`League` = '$league'";
}

if (!empty($_GET['Citizenship'])) {
  $citizenship = $conn->real_escape_string($_GET['Citizenship']); 
  $conditions[] = "p.`Citizenship` = '$citizenship'";
}

if (!empty($_GET['Position'])) {
  $position = $conn->real_escape_string($_GET['Position']); 
  $conditions[] = "p.`Position` = '$position'";
}

if (!empty($_GET['min_market_value']) && !empty($_GET['max_market_value'])) {
  $minMarketValue = (float)$_GET['min_market_value'];
  $maxMarketValue = (float)$_GET['max_market_value'];
  
  // Escape the values to prevent SQL injection
  $minMarketValue = $conn->real_escape_string($minMarketValue);
  $maxMarketValue = $conn->real_escape_string($maxMarketValue);
  
  // Add condition for market value range
  $conditions[] = "p.`marketValue` BETWEEN '$minMarketValue' AND '$maxMarketValue'"; // Range condition
}




// Construire la requête SQL si des conditions existent
$sql = "SELECT 
            p.`id_player`, p.`PlayerName`, p.`Jersey`, p.`Birth Date`, p.`Age`, p.`Height meters`, 
            p.`Citizenship`, p.`Citizenship 2`,p.`Position`, p.`Position 2`, p.`marketValue`, p.`Games Played`,
            p.`ContractExpiration`, p.`NationalTeamGames`,
            a.`Agent`, a.`e-mail` AS email, a.`phone_1`, a.`phone_2`, a.`country`,
            t.`id_team`, t.`Affiliation`, t.`Position_2019`,
            l.`id_league`, l.`League`, l. `Country`
        FROM `player` p
        JOIN `agent` a ON p.`id_agent` = a.`id_agent`
        JOIN `team` t ON p.`id_team` = t.`id_team`
        JOIN `league` l ON t.`id_league` = l.`id_league`";

if (!empty($conditions)) {
    $sql .= " WHERE " . implode(" AND ", $conditions);
}

$result = $conn->query($sql);

?>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Résultats de la recherche - European Soccer</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h1>Résultats de la Recherche</h1>
    <p class="breakdown"><strong>Résultats :</strong> <?php echo $result ? $result->num_rows : 0; ?></p>

    <?php if (!empty($_GET['playerName']) || !empty($_GET['age']) || !empty($_GET['League']) || !empty($_GET['Affiliation']) || !empty($_GET['Citizenship']) || !empty($_GET['Position']) || !empty($_GET['min_market_value']) && !empty($_GET['max_market_value'])): ?>      
      <div>Vous avez recherché : <br>
       <p> <strong><?php echo isset($playerName) ? htmlspecialchars($playerName) : ''; ?></strong></p>
        <p><?php echo isset($age) ? ' Âge: ' . htmlspecialchars($age) : ''; ?></p>
        <p><?php echo isset($affiliation) ? ' Club: ' . htmlspecialchars($affiliation) : ''; ?></p>
        <p><?php echo isset($league) ? ' League: ' . htmlspecialchars($league) : ''; ?></p>
        <p><?php echo isset($citizenship) ? ' Nationalité: ' . htmlspecialchars($citizenship) : ''; ?></p>
        <p><?php echo isset($position) ? ' Position: ' . htmlspecialchars($position) : ''; ?></p>
        <p><?php echo isset($minMarketValue) ? ' Valeur du Marché Minimum (€): ' . htmlspecialchars($minMarketValue)/1000000 : ''; ?></p>
        <p><?php echo isset($maxMarketValue) ? ' Valeur du Marché Maximum (€): ' . htmlspecialchars($maxMarketValue)/1000000 : ''; ?></p>
      </div>

      
      <?php if ($result && $result->num_rows > 0): ?>
        <?php while ($row = $result->fetch_assoc()): ?>
          <div class="result">
            <h2><?php echo htmlspecialchars($row['PlayerName']); ?></h2>
            <p><strong>Nationalité :</strong> <?php echo htmlspecialchars($row['Citizenship']); ?></p>
            <p><strong>Deuxième nationalité :</strong> <?php echo htmlspecialchars($row['Citizenship 2']); ?></p>
            <p><strong>Position principale:</strong> <?php echo htmlspecialchars($row['Position']); ?></p>
            <p><strong>Position secundaire:</strong> <?php echo htmlspecialchars($row['Position 2']); ?></p>
            <p><strong>Date de naissance :</strong> <?php echo htmlspecialchars($row['Birth Date']); ?></p>
            <p><strong>Âge :</strong> <?php echo htmlspecialchars($row['Age']); ?></p>
            <p><strong>Taille (mètres) :</strong> <?php echo htmlspecialchars($row['Height meters']); ?></p>
            <p><strong>Numéro de maillot :</strong> <?php echo htmlspecialchars($row['Jersey']); ?></p>
            <hr>
            <h3>Statistiques du joueur</h3>
            <p><strong>Valeur du Marché (€) : </strong> <?php echo number_format($row['marketValue'] / 1000000); ?> M€</p>
            <p><strong>Fin du contrat : </strong> <?php echo htmlspecialchars($row['ContractExpiration']); ?></p>
            <p><strong>Matches joués :</strong> <?php echo htmlspecialchars($row['Games Played']); ?></p>
            <p><strong>Matches jouées par  l'équipe nationale :</strong> <?php echo htmlspecialchars($row['NationalTeamGames']); ?></p>
            <hr>
            <h3>Statistiques du club</h3>
            <p><strong>Équipe affiliée :</strong> <?php echo htmlspecialchars($row['Affiliation']); ?></p>
            <p><strong>League affiliée :</strong> <?php echo htmlspecialchars($row['League']); ?></p>
            <p><strong>Pays de la league :</strong> <?php echo htmlspecialchars($row['Country']); ?></p>
            <p><strong>Position dans le championnat de 2019:</strong> <?php echo htmlspecialchars($row['Position_2019']); ?></p>
            <hr>
            <h3>Détails de l'Agent</h3>
            <p><strong>Nom de l'agent :</strong> <?php echo htmlspecialchars($row['Agent']); ?></p>
            <p><strong>Email :</strong> <?php echo htmlspecialchars($row['email']); ?></p>
            <p><strong>Téléphone 1 :</strong> <?php echo htmlspecialchars($row['phone_1']); ?></p>
            <p><strong>Téléphone 2 :</strong> <?php echo htmlspecialchars($row['phone_2']); ?></p>
            <p><strong>Pays :</strong> <?php echo htmlspecialchars($row['country']); ?></p>
          </div>
        <?php endwhile; ?>
      <?php else: ?>
        <p>Aucun joueur trouvé correspondant à la recherche.</p>
      <?php endif; ?>
    <?php else: ?>
      <p>Veuillez entrer différents paramètres pour effectuer la recherche.</p>
    <?php endif; ?>

    <a href="search.php" class="back-button">Retour à la recherche</a>
  </div>

  <?php $conn->close(); ?>
</body>
</html>
