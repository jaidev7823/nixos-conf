services.gammastep = {
  enable = true;
  provider = "manual";
  latitude = 40.7;    # Replace with your lat
  longitude = -74.0;  # Replace with your long
  
  # Optional: adds a tray icon if you have a status bar
  tray = true;

  # Optional: custom temperatures (default is usually 6500K day / 3500K night)
  temperature = {
    day = 6000;
    night = 4000;
  };
};
