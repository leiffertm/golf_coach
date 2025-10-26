# Custom Club Distances

This app now supports custom club carry distances loaded from a JSON file. This allows you to set your own personal club distances that will be used as defaults throughout the app.

## How to Use

1. **Edit the JSON file**: Open `assets/custom_club_distances.json`
2. **Fill in your distances**: Replace `null` values with your actual min/max carry distances for each club
3. **Save the file**: The app will automatically load your custom distances on startup

## JSON Format

```json
{
  "driver": { "min": 250, "max": 280 },
  "w3": { "min": 220, "max": 240 },
  "w5": { "min": 200, "max": 220 },
  "h3": { "min": 190, "max": 210 },
  "h4": { "min": 180, "max": 200 },
  "i3": { "min": 190, "max": 205 },
  "i4": { "min": 180, "max": 195 },
  "i5": { "min": 170, "max": 185 },
  "i6": { "min": 160, "max": 175 },
  "i7": { "min": 150, "max": 165 },
  "i8": { "min": 140, "max": 155 },
  "i9": { "min": 130, "max": 145 },
  "pw": { "min": 115, "max": 130 },
  "gw": { "min": 100, "max": 115 },
  "sw": { "min": 80, "max": 100 },
  "lw": { "min": 60, "max": 85 }
}
```

## Important Notes

- **Leave as `null`**: If you don't want to customize a club's distance, leave both `min` and `max` as `null`
- **Valid ranges**: Make sure `min` is less than or equal to `max`
- **Units**: All distances are in yards
- **App restart**: You need to restart the app after changing the JSON file

## What Happens

1. **Default distances**: Your custom distances replace the built-in default distances
2. **Settings pre-filled**: The settings screen will show your custom distances already filled in
3. **Shot generation**: The app will use your custom distances when generating random shots
4. **Fallback**: If a club has `null` values, the app will use the original default distances

## Example

If you only want to customize your driver and 7-iron:

```json
{
  "driver": { "min": 260, "max": 290 },
  "i7": { "min": 155, "max": 170 }
}
```

All other clubs will use the default distances, but your driver and 7-iron will use your custom values.
