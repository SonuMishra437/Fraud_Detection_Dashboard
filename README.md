
# Fraud Detection Dashboard

### Dashboard Link :

## Problem Statement

This dashboard helps in fraud detection in transactions and understand the customers better. It helps how Fraud Behavior affect transactions Mostly Fraud Cases Occurs 
Transaction Type Transfer,cash_out,and How Fraud Behavior Change Over the time it is also in Transfer,cash_out category of Transactions.How many distinct accounts appear more than once in Fraud case.how many senders accounts having zero account balance in Genuine or Fraud case.How many receiver accounts having zero account balance in Genuine or Fraud case.what is  Average Fraud Amount in Each Transactions Type,How many Fraud Transactions,what is Total Transactions,what are the Fraud rate,How many actual Fraud Transactions .so that stakeholders get to know they make informed decision  & thus they can improve these Problems by identifying these area. It also lets them know them Fraud Percentage By in Each Transactions, thus since by using this dashboard they have identified these problem, they can further work on factors responsible for these unwanted Fraud.

### Steps followed 
- Step 1 : I Use Multiple Tools To Complete This Project Like SQL,Python,Power BI
- Step 2 : First Load Csv Dataset contain 6 million raws into SQL 
- Step 3 : apply sql query to ask the question from dataset
- Step 4 : since dataset contain 6 million raws so i create schema before importing & Then insert values into table.
- Step 5 : It was observed that in none of the columns errors & empty values.
- Step 6 : For calculating average Fraud amount in sql i write this sql query select `type` as transactions_method,avg(amount) as avg_amount from
transactions group by `type`;
- Step 7 : For Calculating Total Transactions By Each Transactions Type i write this sql query select count(*) as total_transactions,`type` as transactions_method from
transactions group by `type`;
- Step 8 : Since the data contains Frauds in different Transactions Type, thus in order to represent Fraud count, i write this sql query select count(*) as total_transactions,`type` as transactions_method,sum(if(isfraud = 1,1,0)) fraud_count from 
transactions group by `type`;
- Step 9 : In Order To Calculating Fraud Percentage In Each Transactions Type i simply write this sql query select `type` as transactions_method,(sum(if(isfraud = 1,1,0))/count(*))*100 'fraud_%' from 
transactions group by `type`;
- Step 10 : In Order To Detection of Fraud in each Transactions Type this sql query i use -- 5. Which type values actually contain fraud, and how many fraud cases per type
select `type` as transactions_method,count(isfraud) as actual_fraud from transactions
where isfraud = 1
group by `type` etc.I Also Attached My SQL Query To Complete This Project.
           
- Step 11 : Next When Comes To Python Then I am load dataset From SQL To Python Here I Use Database Connector SQLALCHEMY(SQLAlchemy is a Python library for working with SQL) databases
- Step 12 : For calculating Total descrepency in each transaction Type in python i use this query
- des_crepency = """

select type,
    count(*) as total_transactions,
    sum(abs(case when `type` = 'CASH_IN'
                 then oldbalanceorg + amount - newbalanceOrig
                 else oldbalanceorg - amount - newbalanceOrig end))*100/sum(amount) as total_discrepancy_pct
    
from transactions
group by type;
"""

dess_crepency_pct = pd.read_sql(des_crepency,engine)
dess_crepency_pct

## output 

|   | type     | total_transactions | total_discrepancy_pct |
|---|----------|-------------------:|----------------------:|
| 0 | PAYMENT  | 2151495            | 51.147731             |
| 1 | TRANSFER | 532909             | 95.151393             |
| 2 | CASH_OUT | 2237500            | 83.803841             |
| 3 | DEBIT    | 41432              | 36.435127             |
| 4 | CASH_IN  | 1399284            | 0.002984              |

In This We can easily see in transaction Type Transafer,Cash_out much more descrepency Also this Two Category Contain High Number Of Frauds.
For Example in Cash_out Category 4116 count of Fraud Transactions and Transfer Category contain 4097 count of Frauds

However Fraud rate in Cash_out Category is 18.4% and Transfer Category contain 76.88% Fraud rate .

- Step 13 : For Analysis of Percentage of receiver accounts having zero account balancerec_acc =  """

SELECT isFraud,
       SUM(CASE WHEN newbalanceDest = 0 THEN 1 ELSE 0 END) AS receiver_zero_balance_count,
       COUNT(*) AS total_transactions,
       ROUND(SUM(CASE WHEN newbalanceDest = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) 
       AS receiver_zero_pct
FROM transactions
where namedest not  like 'M%'
GROUP BY isFraud;

"""

- rec_acct = pd.read_sql(rec_acc,engine)
- rec_acct
- plt.figure(figsize=(10, 10))
- plt.pie(rec_acct['receiver_zero_pct'],labels  = ['Fraud_case','Genuine_case'],colors = ["#6c5ce7","#00cec9"], 
    startangle=45,  wedgeprops={'width': 0.4})
- plt.title('receiver_zero_pct')
- plt.legend(['Fraud_case','Genuine_case'],loc = 'upper right')
- plt.axis('equal')
- plt.show()

<img width="910" height="811" alt="output" src="https://github.com/user-attachments/assets/87acd414-8937-4a8a-8c25-4a7395593e3b" />

## Output

| isFraud   |   receiver_zero_balance_count |   total_transactions |   receiver_zero_pct |
|:----------|------------------------------:|---------------------:|--------------------:|
| Fraud     |                          4091 |                 8213 |               49.81 |
| Genuine   |                        283847 |              4202912 |                6.75 |

- In Each 2 fraud transactions after one Fraud Transactions receiver account balance  is zero.
- In Fraud Case → 49.81% emptied and In Genuine Case → 6.75% emptied
- Fraudulent transactions are 7.4× more likely than genuine transactions to leave the receiving account with a zero balance.


 
- Step 14 : for calculating Flagged transactions in pandas i have write flagged_trans =
   """
  select type  ,sum(case when isFraud = 1 then 1 else 0 end) as fraud_count,
 sum(if(isFlaggedFraud=1,1,0)) as isFlaggedFraud,count(*) as total_transactions from transactions
 group by type
  """
trans =  pd.read_sql(flagged_trans,engine).

## output
 type     |   fraud_count |   isFlaggedFraud |   total_transactions |
|:---------|--------------:|-----------------:|---------------------:|
| PAYMENT  |             0 |                0 |              2151495 |
| TRANSFER |          4097 |               16 |               532909 |
| CASH_OUT |          4116 |                0 |              2237500 |
| DEBIT    |             0 |                0 |                41432 |
| CASH_IN  |             0 |                0 |              1399284 |
- Step 15 : Calculated column was created in which, customers were grouped into various age groups.

- for creating fraud count by transactions type i have written code 
- x = trans.plot(
    x='type',
    y='fraud_count',
    kind='bar',
    figsize=(8, 5),
    legend=False,color = ['purple','darkmagenta']
)

- plt.ylabel('Fraud_count')
- plt.xlabel('Transactions_type')
plt.title('Fraud Count by transactions Type',color = 'purple')

-----------------------------------------------------------------------------------------------------------------------------------
<img width="708" height="537" alt="outpu1" src="https://github.com/user-attachments/assets/27ea6ac7-5bda-4e59-ada4-3af250256b55" />

In This Bar Chart We can See Actual Fraud Category is Cash_out and Transfer.

- step - 15 And Next Comes To Power Bi i load dataset From mysql to Power Bi
- Step 16 : New measure was created to find total count of customers.

Following DAX expression was written for the same,
        
        Count of Customers = COUNT(airline_passenger_satisfaction[ID])
        
A card visual was used to represent count of customers.

![Snap_Count](https://user-images.githubusercontent.com/102996550/174090154-424dc1a4-3ff7-41f8-9617-17a2fb205825.jpg)

        
 - Step 16 : New measure was created to find  % of customers,
 
 Following DAX expression was written to find % of customers,
 
         % Customers = (DIVIDE(airline_passenger_satisfaction[Count of Customers], 129880)*100)
 
 A card visual was used to represent this perecntage.
 
 Snap of % of customers who preferred business class
 
 ![Snap_Percentage](https://user-images.githubusercontent.com/102996550/174090653-da02feb4-4775-4a95-affb-a211ca985d07.jpg)

 
 - Step 17 : New measure was created to calculate total distance travelled by flights & a card visual was used to represent total distance.
 
 Following DAX expression was written to find total distance,
 
         Total Distance Travelled = SUM(airline_passenger_satisfaction[Flight Distance])
    
 A card visual was used to represent this total distance.

 ![Snap_3](https://user-images.githubusercontent.com/102996550/174091618-bf770d6c-34c6-44d4-9f5e-49583a6d5f68.jpg)
 
 - Step 18 : The report was then published to Power BI Service.
 
 
![Publish_Message](https://user-images.githubusercontent.com/102996550/174094520-3a845196-97e6-4d44-8760-34a64abc3e77.jpg)

# Snapshot of Dashboard (Power BI Service)

![dashboard_snapo](https://user-images.githubusercontent.com/102996550/174096257-11f1aae5-203d-44fc-bfca-25d37faf3237.jpg)

 
 # Report Snapshot (Power BI DESKTOP)

 https://github.com/user-attachments/assets/51262a6b-acfd-4dde-84de-5f78f463d73c

# Insights

A Three page report was created on Power BI Desktop & it was then published to Power BI Service.

Following inferences can be drawn from the dashboard;

### [1] Avg Fraud Amount = 1.4M($)

   Avg Fraud Amount in Transfer = 14,80,891.67($)
   
   Avg Fraud Amount in Cash_out = 14,55,102.59($)

  Remaining Category(Payment,Cash_IN,Debit) Does not Contain Frauds
       thus Higher Number Fraud Contain Category is Transfer,Cash_out
           
### [2] In Transfer(4097) and Cash_out(fraud Count = 4116) Category Fraud Count in Cash_out is more than transfer
### While Fraud rate in Transfer(76.88%) is more than Cash_out(18.4%)
  
  ### [3] Average Delay 
  
      a) Average delay in arrival(minutes) - 15.09
      b) Average delay in departure(minutes) - 14.71
Average delay will change if different visual filters will be applied.

 ### [4] Some other insights
 
 ### Class
 
 1.1) 47.87 % customers travelled by Business class.
 
 1.2) 44.89 % customers travelled by Economy class.
 
 1.3) 7.25 % customers travelled by Economy plus class.
 
         thus, maximum customers travelled by Business class.
 
 ### Age Group
 
 2.1)  21.69 % customers belong to '0-25' age group.
 
 2.2)  52.44 % customers belong to '25-50' age group.
 
 2.3)  25.57 % customers belong to '50-75' age group.
 
 2.4)  0.31 % customers belong to '75-100' age group.
 
         thus, maximum customers belong to '25-50' age group.
         
### Customer Type

3.1) 18.31 % customers have customer type 'First time'.

3.2) 81.69 % customers have customer type 'returning'.
       
       thus, more customers have customer type 'returning'.

### Type of travel

4.1) 69.06 % customers have travel type 'Business'.

4.2) 30.94 % customers have travel type 'Personal'.

        thus, more customers have travel type 'Business'.
