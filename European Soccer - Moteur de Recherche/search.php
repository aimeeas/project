<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>European Soccer - Recherche Joueur</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h1>European Soccer</h1>
    <form action="results.php" method="GET">
        <label for="playerName">Nom du Joeur</label>
        <input type="text" name="playerName" placeholder="Entrez le nom du joueur...">
        
        <label for="age">Âge</label>
        <input type="number" name="age" placeholder="Entrez l'âge du joueur ...">

        <label for="Affiliation">Club</label>
        <select name="Affiliation" id="Affiliation">
          <option value="">Sélectionnez un club</option>
          <?php
          // Connexion à la base de données
          $conn = new mysqli("localhost", "root", "root", "European_Soccer");
  
          if ($conn->connect_error) {
              die("Échec de la connexion: " . $conn->connect_error);
          }
  
          // Récupérer les affiliations uniques des équipes
          $sql = "SELECT DISTINCT Affiliation FROM team ORDER BY Affiliation ASC";
          $result = $conn->query($sql);
  
          if ($result && $result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                  $affiliation = trim($row['Affiliation']); // Remove unwanted spaces
                  echo '<option value="' . htmlspecialchars($affiliation, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars($affiliation, ENT_QUOTES, 'UTF-8') . '</option>';
              }
          }
  
          $conn->close();
          ?>
      </select>

      <label for="League">League</label>
      <select name="League" id="League">
          <option value="">Sélectionnez une league</option>
          <?php
          // Connexion à la base de données
          $conn = new mysqli("localhost", "root", "root", "European_Soccer");
  
          if ($conn->connect_error) {
              die("Échec de la connexion: " . $conn->connect_error);
          }
  
          // Récupérer les affiliations uniques des équipes
          $sql = "SELECT DISTINCT League FROM league ORDER BY League ASC";
          $result = $conn->query($sql);
  
          if ($result && $result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                  $league = trim($row['League']); // Remove unwanted spaces
                  echo '<option value="' . htmlspecialchars($league, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars($league, ENT_QUOTES, 'UTF-8') . '</option>';
              }
          }
  
          $conn->close();
          ?>
      </select>

      <label for="Citizenship">Nationalité</label>
        <select name="Citizenship" id="Citizenship">
          <option value="">Sélectionnez une nationalité</option>
          <?php
          // Connexion à la base de données
          $conn = new mysqli("localhost", "root", "root", "European_Soccer");
  
          if ($conn->connect_error) {
              die("Échec de la connexion: " . $conn->connect_error);
          }
  
          // Récupérer les nationalités uniques des joueurs
          $sql = "SELECT DISTINCT Citizenship FROM player ORDER BY Citizenship ASC";
          $result = $conn->query($sql);
  
          if ($result && $result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                  $citizenship = trim($row['Citizenship']); // Remove unwanted spaces
                  echo '<option value="' . htmlspecialchars($citizenship, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars($citizenship, ENT_QUOTES, 'UTF-8') . '</option>';
              }
          }
  
          $conn->close();
          ?>
      </select>

      <label for="Position">Position</label>
        <select name="Position" id="Position">
          <option value="">Sélectionnez une position</option>
          <?php
          // Connexion à la base de données
          $conn = new mysqli("localhost", "root", "root", "European_Soccer");
  
          if ($conn->connect_error) {
              die("Échec de la connexion: " . $conn->connect_error);
          }
  
          // Récupérer les nationalités uniques des joueurs
          $sql = "SELECT DISTINCT Position FROM player ORDER BY Position ASC";
          $result = $conn->query($sql);
  
          if ($result && $result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                  $position = trim($row['Position']); // Remove unwanted spaces
                  echo '<option value="' . htmlspecialchars($position, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars($position, ENT_QUOTES, 'UTF-8') . '</option>';
              }
          }
  
          $conn->close();
          ?>
      </select>

      <label for="marketValue">Valeur du Marché (€): 
      </label>

               <div class="slider-container">
            <div class="slider">
                <div class="range" id="range"></div>
                <label for="marketValue">Min: <span id="minValueDisplay"> M€</span> </label>
                <input type="range" id="minRange" name="min_market_value" min="0" max="200000000" step="1000000" value="0">
                <br>
                <label for="marketValue">Max: <span id="maxValueDisplay"> M€</span></label>
                <input type="range" id="maxRange" name="max_market_value" min="0" max="200000000" step="1000000" value="0">
            </div>



      <!-- JavaScript for Live Updating Slider -->
      <script>
        const minSlider = document.getElementById("minRange");
        const maxSlider = document.getElementById("maxRange");
        const minValueDisplay = document.getElementById("minValueDisplay");
        const maxValueDisplay = document.getElementById("maxValueDisplay");
        const range = document.getElementById("range");

        function updateSlider() {
            let minValue = parseInt(minSlider.value);
            let maxValue = parseInt(maxSlider.value);

            // Ensure min is never greater than max
            if (minValue >= maxValue) {
                minSlider.value = maxValue - 1000000; // Keep a gap of 1M
                minValue = maxValue - 0;
            }

            // Update displayed values
            minValueDisplay.textContent = minValue/1000000 + " M€";
            maxValueDisplay.textContent = maxValue/1000000 + " M€";

            // Adjust the blue range bar
            let minPercent = (minValue / 500) * 100;
            let maxPercent = (maxValue / 500) * 100;
            range.style.left = minPercent + "%";
            range.style.width = (maxPercent - minPercent) + "%";
        }

        // Event listeners for real-time updates
        minSlider.addEventListener("input", updateSlider);
        maxSlider.addEventListener("input", updateSlider);

        // Initialize display on page load
        updateSlider();
    </script>



        <button type="submit">Rechercher</button>
        </form>
  </div>
</body>
</html>