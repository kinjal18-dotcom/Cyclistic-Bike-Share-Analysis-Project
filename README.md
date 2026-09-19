# Cyclistic Bike-Share Analysis: Google Data Analytics Capstone Project

The **Cyclistic Bike-Share Case Study** has been completed as the final capstone project for the **Google Data Analytics Professional Certificate**. 

This project demonstrates an end-to-end data analysis workflow, from raw data extraction and cross-quarter schema alignment in Google BigQuery to visual storytelling and strategic recommendations in Tableau.

---

##  Project Overview & Business Case

### The Company
Cyclistic is a fictional bike-share system operating in Chicago with a fleet of over 5,800 bicycles and 600 tracking stations. The service offers standard two-wheel bikes along with inclusive options like hand tricycles and adaptive bicycles. 

### The Business Problem
Cyclistic’s finance team concluded that **annual subscribers are significantly more profitable than single-ride or full-day casual riders**. While casual riders are already familiar with the service, the marketing team needs to design strategies that convert casual riders into annual members rather than spending resources on acquiring entirely new customers.

### Key Questions to Answer
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy a Cyclistic annual membership?
3. How can Cyclistic use digital media to influence casual riders to become members?

---

## Tools Used

* **SQL (Google BigQuery):** BigQuery was used to import, union, standardize, and aggregate over 3.8 million trip records across four separate quarterly datasets for 2019.
* **Tableau Desktop / Public:** Used to create interactive visualizations and dashboards identifying hourly, daily, and duration patterns.

---

## Data Cleaning & Processing (Ask, Prepare, Process)

The dataset consists of four raw CSV files covering Cyclistic trip data across all four quarters of 2019 (`DataQ1` through `DataQ4`). 

### Key Processing Challenges & Solutions
1. **Inconsistent Schemas across Quarters:**
   * **Q1, Q3, and Q4** shared consistent column structures (`trip_id`, `start_time`, `end_time`, `bikeid`, `tripduration`, `from_station_id`, `from_station_name`, `to_station_id`, `to_station_name`, `usertype`, `gender`, `birthyear`).
   * **Q2** used a different layout with descriptive multi-word headers (`01 - Rental Details Rental ID`, `01 - Rental Details Local Start Time`, `User Type`, etc.).
   * **Solution:** Used BigQuery CTEs (`q1_data` through `q4_data`) to select and standardize field aliases across all four quarters before combining them via `UNION ALL`.

2. **Data Cleansing Steps:**
   * Standardized user terminology: Converted legacy `Subscriber` tags to `Member` and `Customer` tags to `Casual`.
   * Standardized data types (`CAST` for strings, timestamps, and numeric durations).
   * Filtered out corrupted records: Removed trips with non-positive durations ($\le 0$ seconds), trips lasting longer than 24 hours ($> 86,400$ seconds), and records with missing station details.
   * Engineered analytical features: Calculated `ride_length_minutes`, extracted `day_of_week`, `day_of_week_num`, and `start_hour` to prepare the data for Tableau.

*SQL Code can be viewed here: [`sql/cyclistic_full_analysis.sql`](./sql/cyclistic_full_analysis.sql).*

---

## Key Insights & Findings

<img width="1604" height="850" alt="image" src="https://github.com/user-attachments/assets/294a0dee-1d71-4875-a79b-8ce45ad45f03" />

### 1. Trip Duration Disparity
* **Casual Riders** take significantly longer trips, averaging **~38.7 minutes** per ride.
* **Annual Members** take shorter, highly focused trips, averaging **~13.4 minutes** per ride.
* **Takeaway:** Casual riders use the service primarily for leisure, sight-seeing, or recreational weekend travel, while Members view the bikes as utilitarian transportation.

### 2. Hourly Usage Patterns (Commuter vs. Leisure)
* **Members** show two sharp daily peaks at **8:00 AM (~280K trips)** and **5:00 PM (~390K trips)** on weekdays.
* **Casual Riders** exhibit a smooth curve that steadily builds throughout late morning and peaks around **5:00 PM**, with no morning rush-hour spike.
* **Takeaway:** Members rely heavily on Cyclistic for routine work/school commutes.

### 3. Weekly Volume Distribution
* **Members** dominate weekday volume, with usage peaking Tuesday through Thursday.
* **Casual Riders** peak heavily on Saturday and Sunday, driving the majority of weekend leisure activity.

---

## 🚀 Strategic Recommendations (Act)

Based on these insights, here are three actionable, data-backed recommendations for Cyclistic’s marketing director:

1. **Targeted Seasonal & Weekend Conversion Campaigns:**
   * Launch digital marketing campaigns on Friday afternoons and weekends near top tourist/recreational stations targeting casual riders.
   * Frame annual memberships not as a yearly commitment, but as a money-saver for frequent weekend riders.

2. **Introduce "Commuter Pass" Incentives / Weekend Member Perks:**
   * Create a targeted promotion highlighting how much money regular casual users could save on weekday morning commutes.
   * Offer exclusive weekend perks (e.g., free guest passes or priority bike access) for annual subscribers to make memberships more attractive to weekend leisure riders.

---

## 📁 Repository Structure

* `README.md` – Executive summary, workflow, and case study documentation.
* `Cyclistic_Case_Study_Prompt.pdf` – Original case study guidelines provided by Google.
* `sql/` – Cleaned and standardized BigQuery SQL query scripts.
* `data/processed` – Contains processed aggregated CSV output.
