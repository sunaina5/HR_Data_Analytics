# HR_Data_Analytics

This project follows a complete end-to-end data analysis and ML workflow:

✅ Cleaned and transformed raw HR data using SQL - 
    SQL Part:
	1.	Database design & table creation
	2.	Exploratory querying to understand attrition trends
	3.	Data cleaning & validation
	4.	Feature engineering before modeling
	5.	Translating business questions into SQL logic


✅ Performed EDA and trained predictive models using Python


✅ Used SHAP for feature importance and model explainability

Overall Key Insights:

•	XGBoost is the most balanced model post-tuning, especially for class 1 (attrition).
•	Logistic Regression and Random Forest struggle to capture class 1 well.
•	If your business goal is to catch potential attrition risks, tuned XGBoost is your best pick despite a slight accuracy trade-off.
Recommendations for HR Team

Based on model insights and feature analysis:

🔹 Monitor Overtime: Employees working overtime have the highest attrition rates. Review workload distribution and encourage better work-life balance.

🔹 Support Low Job Satisfaction: Introduce frequent check-ins, employee engagement surveys, and career growth paths for employees reporting low satisfaction.

🔹 Adjust Compensation Fairly: Attrition is higher among those earning < $10,000/month. Consider reviewing salary structure, especially for junior and mid-level roles.

🔹 Target Sales & Travel-heavy Roles: High attrition observed in Sales Representatives and those who Travel Frequently. Offer flexible travel policies and incentives.

🔹 Prioritize Single Employees: Singles showed a higher tendency to leave. Explore their job satisfaction factors and professional development interest.

Our machine learning model (XGBoost) enables HR to proactively identify high-risk employees, understand why they might leave, and take data-driven actions to reduce attrition
