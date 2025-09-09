# ☕ Monday Coffee — SQL Business Analysis Project  

## 📌 Project Overview  
This project analyzes **Monday Coffee’s** sales database to recommend the **top three Indian cities** for launching new physical coffee shops.  
The analysis covers customer behavior, sales trends, and market potential to guide **data-driven business expansion decisions**.  

---

## 🎯 Business Objectives  
- Estimate potential coffee consumers per city.  
- Calculate total revenue and city-wise performance.  
- Identify top-selling products and customer preferences.  
- Compare average customer spending with estimated city rents.  
- Analyze monthly sales growth trends.  
- Rank cities using a **Market Potential Score** (sales, customers, consumer base).  
- Recommend the best cities for store expansion.  

---

## 🛠️ Techniques & SQL Concepts Applied  
- **Data Aggregation:** `SUM`, `COUNT`, `ROUND` for revenue and sales metrics.  
- **Joins:** combined multiple tables (`sales`, `products`, `customers`, `city`) to unify data.  
- **CTEs (WITH clauses):** structured complex queries for clarity and reusability.  
- **Window Functions:**  
  - `ROW_NUMBER()` → ranking top products by city.  
  - `LAG()` → calculating month-over-month sales growth.  
- **Normalization & Scoring:** built a **composite market potential score** using weighted metrics.  
- **Business KPI Design:** avg sales per customer, rent vs sales ratio, growth rates.  

---

## 📊 Key Insights  
- **Delhi**: Largest customer base and highest estimated coffee consumers → strong flagship potential.  
- **Pune**: High average sales per customer with cost-efficient rent → best ROI city.  
- **Jaipur**: Attractive rent-to-sales ratio with solid customer traction → cost-effective expansion.  

📌 **Recommended Cities for New Stores:** **Pune, Delhi, Jaipur**  

---

## ⚠️ Risks & Next Steps  
**Risks**  
- Data assumptions (sales figures and rent may vary in real-world scenarios).  
- Neighborhood-level rent and footfall variability.  
- Market competition and operational readiness.  

**Next Steps**  
1. Validate sales and rent assumptions with field research.  
2. Scout neighborhoods in Pune, Delhi, and Jaipur for site selection.  
3. Run **90-day pilot stores** to test assumptions.  
4. Track KPIs (daily transactions, avg ticket size, CAC).  
5. Scale expansion based on pilot performance.  

---

## 🚀 Project Value  
This project demonstrates how **SQL can be applied beyond querying** to:  
- Solve a **real-world business problem**.  
- Generate **actionable recommendations** for management.  
- Translate raw data into **strategic decisions**.  

---

## 🧑‍💻 Author  
**Manish Jangir**  
- 🎓 IIT Gandhinagar Graduate | 📊 Data Analyst | 🔍 Product Research Enthusiast  
- Experienced in SQL, Python, and Business Analytics  
- Passionate about turning data into strategy and insights  
