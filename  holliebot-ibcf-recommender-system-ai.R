# Item-Based Collaborative Filtering (IBCF) System
# aka HOLLIE Bot Recommender System
# Highly Optimized Localized Learning and Inference Engine Bot
#
# Developed by: Joe Domaleski
# Country Fried Creative / Country Fried Labs
# Date: 4/1/2025
#
# Refer to blog post for more information:
# https://blog.marketingdatascience.ai
#

library(recommenderlab)  # For recommender system functions
library(ggplot2)         # For creating visualizations
library(reshape2)        # For reshaping data used in plotting
library(ggrepel)         # For improved text label placement on plots
library(proxy)           # For Jaccard distance used in clustering analysis of clients

# --- Parameters ---
n_recs <- 2  # Number of recommendations per client; adjust as needed

# === Step 1: Data Loading & Preparation ===
# Load customer preference data from CSV.
# The CSV file "customer_preferences.csv" contains columns:
# Client, Delicious Website Design, Sweet Talkin SEO, Sunday Best Email Marketing,
# Front Porch Social Media, Porchlight Logo Design, Chicken Influencer Outreach
cust_pref <- read.csv("customer_preferences.csv", stringsAsFactors = FALSE)

# Extract client names and create the preferences matrix
clients <- cust_pref$Client
pref_matrix <- as.matrix(cust_pref[, -1])
pref_matrix <- apply(pref_matrix, 2, as.numeric)  # Ensure numeric values
rownames(pref_matrix) <- clients

# === Step 2: Define Services ===
# The services are derived from the CSV column names.
services <- colnames(pref_matrix)

# === Step 3: Create Binary Data Structure ===
# Convert the preferences matrix to a binaryRatingMatrix (required by recommenderlab)
binary_data <- as(pref_matrix, "binaryRatingMatrix")

# === Step 4: Train the IBCF Model using HOLLIE Bot ===
# HOLLIE Bot (Highly Optimized Localized Learning and Inference Engine Bot) uses IBCF
model <- Recommender(binary_data, method = "IBCF")

# === Step 5: Generate Recommendations ===
# Generate up to n_recs recommendations per client (n_recs set above)
recommendations <- predict(model, binary_data, n = n_recs)
recs_list <- as(recommendations, "list")
names(recs_list) <- rownames(pref_matrix)

# === Step 6: Output Formatted Recommendations ===
# Generate friendly output messages from HOLLIE Bot
recommend_with_flair <- function(user, recs) {
  if (length(recs) == 0) {
    return(paste0("Well sugar, we ain't got enough data on ", user,
                  ". Maybe try tellin' us what y'all like first."))
  } else {
    opening <- paste0("Hey there, ", user, "! Based on what you've been workin' on,")
    flair <- paste("HOLLIE Bot reckons you'd love to try", 
                   paste(recs, collapse = " and "), "next.")
    closing <- "Now get yourself a biscuit while we make it happen. 🤠"
    return(paste(opening, flair, closing))
  }
}

cat("\n--- HOLLIE (Highly Optimized Localized Learning and Inference Engine) Bot Recommendations ---\n\n")
for (user in names(recs_list)) {
  message <- recommend_with_flair(user, recs_list[[user]])
  cat(message, "\n\n")
}

# === Step 7: Generate Visualizations ===
# The following sections create and save plots to visualize the results.

# --- Heatmap of Service Usage ---
# This heatmap shows which clients have used which services.
usage_df <- as.data.frame(pref_matrix)  # Create a data frame from the matrix
usage_df$Client <- rownames(usage_df)
usage_long <- melt(usage_df, id.vars = "Client", variable.name = "Service", value.name = "Used")
usage_long$Used <- factor(usage_long$Used, levels = c(0, 1))
heatmap_plot <- ggplot(usage_long, aes(x = Service, y = Client, fill = Used)) +
  geom_tile(color = "white") +
  scale_fill_manual(values = c("0" = "#f7f7f7", "1" = "#3182bd"),
                    labels = c("Not Used", "Used")) +
  labs(title = "Service Usage Heatmap: What Our Clients Have Used",
       x = "Marketing Services", y = "Client Businesses", fill = "Service Use") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        axis.text.y = element_text(size = 7))
print(heatmap_plot)
ggsave("cfc_usage_heatmap.png", plot = heatmap_plot, width = 10, height = 10)

# --- Bar Chart: Most Recommended Services by HOLLIE Bot ---
# This chart displays the frequency of each service being recommended.
flat_recs <- unlist(recs_list)
rec_counts <- table(factor(flat_recs, levels = services))
rec_df <- data.frame(
  Service = names(rec_counts),
  Count = as.integer(rec_counts)
)
bar_plot <- ggplot(rec_df, aes(x = reorder(Service, Count), y = Count, fill = Service)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = Count), hjust = -0.2, size = 4) +
  coord_flip() +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Most Recommended Services by HOLLIE Bot",
       x = "Service", y = "Number of Recommendations") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"),
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10))
print(bar_plot)
ggsave("cfc_top_recommendations_bar_chart.png", plot = bar_plot, width = 8, height = 6)

# --- Scatterplot: Service Usage vs. Recommendations ---
# This plot compares how often services are used versus how often they're recommended.
service_usage_totals <- colSums(pref_matrix)
rec_df$UsedCount <- service_usage_totals[rec_df$Service]
scatter_plot <- ggplot(rec_df, aes(x = UsedCount, y = Count, label = Service)) +
  geom_point(color = "#3182bd", size = 4) +
  geom_text_repel(size = 3.5, max.overlaps = 20) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray50") +
  labs(title = "Do We Recommend What’s Already Popular?",
       x = "Times a Service Was Used",
       y = "Times Recommended by HOLLIE Bot") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))
print(scatter_plot)
ggsave("cfc_usage_vs_recommendation_scatter.png", plot = scatter_plot, width = 8, height = 6)

# === Step 8: Perform Advanced Analysis ===
# --- Client Profile Clustering ---
# Calculate Jaccard distance for binary data and create a dendrogram.
dist_matrix <- dist(as.matrix(pref_matrix), method = "Jaccard")
hc <- hclust(dist_matrix, method = "average")
# Plot the dendrogram in the RStudio plot window
plot(hc, main = "Dendrogram of Client Profiles", xlab = "Clients", sub = "", cex = 0.8)
rect.hclust(hc, k = 4, border = 2:5)
# Copy the current plot to a PNG file
dev.copy(png, filename = "cfc_client_dendrogram.png", width = 800, height = 600)
dev.off()

