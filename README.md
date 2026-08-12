

# Tesla Solar & Inverter Monitoring Pipeline

## ⚠️ The Problem

Two of the five solar strings connected to my two Tesla Powerwalls have failed. I suspect this is due to a failed inverter. The immediate need is to analyze historical data to determine exactly when this failure occurred, and ultimately, to implement a persistent monitoring setup to catch future hardware degradation or failures.

## 🎯 North Star Objective

To build an automated data ingestion and visualization solution that proactively monitors the health of the solar setup and alerts me when the inverters or strings misbehave.

## 🗺️ The Approach

The project is phased into two parts:

1. **Historical Analysis:** Extract historical energy data from the Tesla APIs to establish baselines and pinpoint the timestamp of the initial inverter failure.
2. **Real-Time Monitoring:** Transition the analysis into an ongoing monitoring dashboard that visualizes current metrics against historical baselines.

## 🏗️ Architecture & Tech Stack

This pipeline runs locally on an Ubuntu server, completely containerized via Docker.

* **Data Ingestion (Python):**
* Utilizes `teslapy` to fetch site-level 15-minute aggregates from the Tesla Cloud API.
* Utilizes `pypowerwall` to interface with the Tesla Energy Gateways for Powerwall and solar power data, explicitly pulling high-frequency string-level diagnostics from the local network.


* **Database (TimescaleDB / PostgreSQL):** Optimized time-series storage utilizing hypertables and continuous aggregates for lightning-fast daily, weekly, and monthly rollups.
* **Frontend (Streamlit):** A web-based dashboard allowing for dynamic, overlapping time-series visualizations (e.g., comparing current performance with T-12 and T-24 month baselines).
* **CI/CD:** Managed via GitHub Actions for automated deployment to the server.
