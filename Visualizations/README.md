# Visualizations

This directory contains interactive Plotly visualizations exported as standalone HTML files.

⚠️ **Note:** GitHub cannot render large HTML files directly.
To view a visualization:

1. Click on the `.html` file
2. Click **Download**
3. Open the file locally in a web browser (Chrome, Firefox, Edge, Safari)

No additional dependencies are required.

---

## File Overview

### GO (Gene Ontology) Visualizations

- **GO Rainbow 1.html**
  - Species are labeled directly on the x-axis
  - Each species is assigned a unique color from the rainbow spectrum

- **GO Rainbow 2.html**
  - Species are shown in a legend instead of on the x-axis
  - Colors correspond to species (rainbow scheme)

- **GO Viridis.html**
  - Uses a perceptually uniform viridis color scale
  - Each species shares the same gradient
  - Color transitions from yellow to dark blue
  - Dark blue regions tend to be visually enriched for differentiation between species
  - Yellow regions tend to highlight more broadly shared or less differentiated patterns
  - The ordering is determined by the underlying R visualization workflow and preserved as-is

---

### Pfam Visualizations

- **Pfam Rainbow 1.html**
  - Species labeled directly on the x-axis
  - Each species assigned a unique rainbow color

- **Pfam Rainbow 2.html**
  - Species displayed in a legend
  - Rainbow color mapping per species

- **Pfam Viridis.html**
  - Uses the same viridis gradient across all species
  - Yellow → green → blue progression
  - Visually resembles ink diffusion or chromatography patterns
  - Ordering is inherited from the R plotting process and not manually imposed

---

## Notes on Color Design

- **Viridis variants** emphasize quantitative structure and are more perceptually uniform
- The viridis scale is generally preferred for accurate interpretation of gradients

---

## File Size

These files are relatively large (~5–10 MB) because they include all data and JavaScript needed for fully interactive, offline use.

---

## Performance Notes

These visualizations are large, self-contained Plotly HTML files.

- They may use significant memory when opened
- Performance is best on systems with ≥16 GB RAM
- On lower-memory devices (e.g., 8 GB laptops), the browser may become slow or unresponsive

If you encounter issues:
- Try opening one file at a time
- Close other browser tabs
- Use Chrome or Firefox for best compatibility