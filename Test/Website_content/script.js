window.onload = function () {
    const form = document.getElementById("predictForm");
  
    form.addEventListener("submit", function (e) {
      e.preventDefault();
  
      const baseUrl = "http://127.0.0.1:11126/predict";
  
      const params = new URLSearchParams({
        bedrooms: document.getElementById("bedrooms").value,
        bathrooms: document.getElementById("bathrooms").value,
        living_area: document.getElementById("living_area").value,
        lot_area: document.getElementById("lot_area").value,
        floors: document.getElementById("floors").value,
      });
  
      const cityMultipliers = {
        "Mumbai": 12,
        "Delhi NCR": 10,
        "Bangalore": 8,
        "Hyderabad": 5,
        "Chennai": 4,
        "Pune": 3,
        "Lucknow": 2.5,
        "Bhopal": 2,
        "Nagpur": 1.8,
        "Other": 1
      };
  
      const mainAreaFactors = {
        "Mumbai": 1.3,
        "Delhi NCR": 1.25,
        "Bangalore": 1.2,
        "Hyderabad": 1.15,
        "Chennai": 1.15,
        "Pune": 1.1,
        "Lucknow": 1.1,
        "Bhopal": 1.05,
        "Nagpur": 1.05,
        "Other": 1
      };
  
      fetch(`${baseUrl}?${params.toString()}`)
        .then(res => res.json())
        .then(data => {
          const basePrice = data.predicted_price;
          const baseMin = data.min_price;
          const baseMax = data.max_price;
  
          let tableHTML = `
            <h2 style="text-align:center;">📊 City-wise House Price Prediction</h2>
            <div class="table-container">
            <table class="price-table" border="1" cellpadding="10">
              <thead>
                <tr>
                  <th>City</th>
                  <th>Estimated Price</th>
                  <th>Price Range</th>
                  <th>Main Area Price Range</th>
                </tr>
              </thead>
              <tbody>
          `;
  
          for (const [city, multiplier] of Object.entries(cityMultipliers)) {
            const predicted = basePrice * multiplier;
            const min = baseMin * multiplier;
            const max = baseMax * multiplier;
  
            const mainFactor = mainAreaFactors[city] || 1;
            const mainMin = (min * mainFactor).toFixed(0);
            const mainMax = (max * mainFactor).toFixed(0);
  
            tableHTML += `
              <tr>
                <td>${city}</td>
                <td>₹${predicted.toFixed(2)}</td>
                <td>₹${min.toFixed(0)} - ₹${max.toFixed(0)}</td>
                <td>${multiplier === 1 ? '—' : `₹${mainMin} - ₹${mainMax}`}</td>
              </tr>
            `;
          }
  
          tableHTML += `</tbody></table></div>`;
          document.getElementById("result").innerHTML = tableHTML;
        })
        .catch(err => {
          console.error("Error:", err);
          document.getElementById("result").innerText = "Failed to fetch prediction.";
        });
    });
  };
  