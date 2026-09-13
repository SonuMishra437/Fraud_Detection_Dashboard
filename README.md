
# Fraud Detection Dashboard

Problem Statement

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
- Step 16 : New measure was created to find Average Fraud Amount.

Following DAX expression was written for the same,
     
     Avg_amount_fraud = CALCULATE(AVERAGE(fraud_detection[amount]),fraud_detection[isFraud]=1)
     
 A card visual was used to represent Average Fraud Amount.
 
 <img width="150" height="101" alt="{771304E5-9D1F-4C12-BBDD-E94070A259E9}" src="https://github.com/user-attachments/assets/f567d380-5d71-4c30-8fb4-00ec90859f09" />

- Step 17 : New measure was created to find Fraud Transactions.
  Following DAX expression was written for the same,
                     

       fraud_trans =  CALCULATE(   COUNTROWS(fraud_detection),fraud_detection[isFraud] = 1)
 A card visual was used to represent Fraud Transactions.
 
 <img width="221" height="109" alt="{AB860FEE-425E-4422-B450-8B0663A101F4}" src="https://github.com/user-attachments/assets/5f302b28-842f-4dbf-abd9-dd066b8cfcdc" />

 - Step 18 : New measure was created to calculate Fraud rate.
 
 Following DAX expression was written to find total distance,
 
         Fraud_rate = DIVIDE([Fraud_transactions],[total_transactions],0)*100
    
 A card visual was used to represent Fraud rate.

<img width="180" height="101" alt="{42A61CB3-8C68-45EA-97E8-D63956F349DC}" src="https://github.com/user-attachments/assets/393347e4-9660-44e7-ba9d-ade6b89459d3" />



# Snapshot of Dashboard 
# First Page
<img width="1376" height="773" alt="image" src="https://github.com/user-attachments/assets/a1d85c71-9c73-48f9-a8a5-579533fb0902" />

# Second Page
<img width="1370" height="773" alt="{CF5ECE9B-1D8F-440C-B9B1-D859D721F86E}" src="https://github.com/user-attachments/assets/a1aa815b-64a3-425e-b0f3-d470bc179cbe" />

# Final Page
<img width="1336" height="742" alt="{03E2F7A3-63F4-4747-916D-D99D2CF82FE7}" src="https://github.com/user-attachments/assets/78974c46-f93e-4739-9ba7-4f6450d1ae59" />


 
 # Project Video

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
  
  ### [3] Fraud Transactions Occurs In  Cash_out,Transafer Category only.
  
      a) Fraud Transactions in Transfer  - 4116
      b) Fraud Transactions in Cash_out - 4097

 
 ### Fraud Behavior Over Time.
 
It Maximum 9th Hour of day 
It Minimum at 23th Hour Of day
      
### Fraud Percentage

3.1) 76.88 % customers have customer type 'First time'.

3.2) 18.40 % customers have customer type 'returning'.
       
       thus,  Fraud rate most Occurs in Transfer 

### Discrepancy Level in Transactions Type.

4.1) Discrepancy rate in Transfer  = 95.15%
4.1) Discrepancy rate in Cash_out  = 83.80%
4.1) Discrepancy rate in Payment  = 51.15%
4.1) Discrepancy rate in Cash_in  = 0.00%
4.1) Discrepancy rate in  Debit  = 36.44%

        thus, Discrepancy Level Order is  Transfer>Cash_out>Payment>Cash_In>Debit
