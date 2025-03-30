# HOLLIE Bot IBCF Recommender System AI

**R-based item-based collaborative filtering (IBCF) recommender system—HOLLIE Bot—that delivers AI-powered marketing recommendations**

## Overview

This repository contains an R-based demonstration of an item-based collaborative filtering recommender system, dubbed **HOLLIE Bot** (Highly Optimized Localized Learning and Inference Engine Bot). The system analyzes customer preference data for various marketing services and generates personalized recommendations, all while maintaining a playful Southern charm. This proof-of-concept illustrates how machine learning can enhance marketing decision-making and even (humorously) replace traditional marketing staff.

## Features

- **Data-Driven Recommendations:** Uses customer preference data to generate targeted marketing service recommendations.
- **IBCF Implementation:** Demonstrates item-based collaborative filtering using the `recommenderlab` package in R.
- **Engaging Output:** Outputs friendly, Southern-flavored recommendation messages from HOLLIE Bot.
- **Visualizations:** Generates plots (heatmap, bar chart, scatterplot, and dendrogram) to illustrate service usage patterns, recommendation frequency, and client clustering.
- **Extensible and Modular:** Easy-to-adjust parameters and CSV-based data input allow you to customize the system for your own use.

## Prerequisites

Ensure you have R installed on your system. The following R packages are required:

- `recommenderlab`
- `ggplot2`
- `reshape2`
- `ggrepel`
- `proxy`

You can install any missing packages using `install.packages("packageName")`.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/holliebot-ibcf-recommender-system-ai.git
   ```
2.	Open the project in RStudio (or your preferred R environment).
3.	Ensure that the file customer_preferences.csv is located in the project’s working directory.

## Usage

1. Open the `holliebot-ibcf-recommender-system-ai.R` script in RStudio.
2. Modify the parameter `n_recs` at the top of the script if you wish to change the number of recommendations per client.
3. Run the script to generate recommendations and visualizations.
4. The script outputs HOLLIE Bot’s friendly recommendations to the console and saves the following visualizations as PNG files:
   - `cfc_usage_heatmap.png`
   - `cfc_top_recommendations_bar_chart.png`
   - `cfc_usage_vs_recommendation_scatter.png`
   - `cfc_client_dendrogram.png`

## Code Walkthrough

On my Marketing Data Science blog (https://blog.marketingdatascience.ai), we provide a detailed walkthrough of each step in this script—from loading the data to generating and visualizing recommendations—explaining both the technical and practical aspects of IBCF and how HOLLIE Bot delivers AI-powered marketing recommendations.

## Contributing

Contributions, bug reports, and feature suggestions are welcome! Please open an issue or submit a pull request.

## License

MIT License

## Contact

For further information or questions, please contact me here or by commenting on my blog post about this system.
