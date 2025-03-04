# End-to-End Data Architecture for Leather Shoe Company

![GitHub repo size](https://img.shields.io/github/repo-size/your-repo/leather-shoe-data-architecture) ![GitHub contributors](https://img.shields.io/github/contributors/your-repo/leather-shoe-data-architecture) ![GitHub issues](https://img.shields.io/github/issues/your-repo/leather-shoe-data-architecture)

## Project Description
This project establishes a comprehensive **End-to-End Data Architecture** for a Leather Shoe Company, addressing inefficiencies in data management, financial record-keeping, and business insight generation. By leveraging a scalable **data warehouse** and a **Flask-based web application**, the system provides real-time performance insights and automates financial tracking.

**Note:** This repository contains only the **key structural components** of the project. Most **confidential code and sensitive information** have been removed. As a result, the application **will not be able to launch** in its current state. However, this documentation provides an overview of the **system design and architecture**.

## Table of Contents
- [Project Description](#project-description)
- [Key Features](#key-features)
- [Installation](#installation)
- [Usage](#usage)
- [Technology Stack](#technology-stack)
- [Data Flow Architecture](#data-flow-architecture)
- [Badges](#badges)
- [Contributing](#contributing)
- [License](#license)

## Key Features
- **Flask Web Application**: User-friendly dashboard for performance monitoring and financial record-keeping.
- **Data Warehouse Integration**: Implementation of **AWS Redshift** for advanced analytics.
- **ETL Pipelines**: Automated data ingestion and transformation using **AWS Glue**.
- **OpenAI API Integration**: AI-powered insights extracted from structured business data.
- **SQL Server Support**: Support for legacy data storage and third-party integration.
- **Security & Access Control**: Secure authentication and admin management via **Flask-Login**.

## Installation
### Prerequisites
Ensure you have the following installed:
- Python 3.x
- Flask
- MySQL & Redshift Connectors
- AWS Account with **Redshift, S3, and Glue** services

### Setup Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/leather-shoe-data-architecture.git
   cd leather-shoe-data-architecture
   ```
2. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
3. Set up environment variables:
   ```sh
   cp .env.example .env
   ```
   Edit `.env` with your **AWS Redshift, MySQL, and OpenAI API keys**.
4. Initialize the database to verify if the connection is functioning:
   ```sh
   python database.py
   ```
5. Run the admin application to setup an admin account:
   ```sh
   python app.py
   ```
6. Run the Flask application:
   ```sh
   python app.py
   ```
## Usage
### Web Application
- **Login** to access the admin dashboard.
- **Upload financial records** for automated processing.
- **View business insights** through data-driven visualizations.
- **Generate AI-powered explanations** of sales and financial trends.

### ETL Pipeline
- **AWS Glue extracts** data from AWS RDS & SQL Server.
- **Data transformation occurs** in AWS Glue before loading into **Redshift**.
- **Business intelligence insights** are generated from Redshift and displayed in Flask.

## Technology Stack
| Component   | Technology |
|------------|------------|
| Web Framework | Flask |
| Database | MySQL (AWS RDS), Redshift |
| Data Pipeline | AWS Glue, S3 |
| Programming Language | Python |
| Machine Learning | OpenAI API |
| Deployment | AWS EC2 |

## Data Flow Architecture
1. **Data Ingestion**:
   - Transactional data from **SQL Server**
   - Web application data stored in **AWS RDS**
2. **Data Transformation**:
   - **AWS Glue** cleanses and processes data
   - Staged data stored in **Amazon S3**
3. **Data Storage**:
   - Transformed data loaded into **Amazon Redshift**
4. **Business Insights**:
   - Flask app queries Redshift for analytics
   - OpenAI API extracts insights

## Badges
Badges help display key project statistics and links to important tools. These badges automatically update themselves:

![GitHub repo size](https://img.shields.io/github/repo-size/your-repo/leather-shoe-data-architecture) ![GitHub contributors](https://img.shields.io/github/contributors/your-repo/leather-shoe-data-architecture) ![GitHub issues](https://img.shields.io/github/issues/your-repo/leather-shoe-data-architecture)

For more badges, visit [Shields.io](https://shields.io/).

## Contributing
This project is intended for demonstration purposes and is not open to external contributions.