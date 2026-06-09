from massive import RESTClient
from datetime import datetime
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from io import BytesIO
import boto3

BUCKET = "stock-market-pipeline-bronze-dev"
s3 = boto3.client("s3")

def ingestion(tickers,api_key):

    

    client = RESTClient(api_key=api_key)

    #TICKERS = ["AAPL", "GOOGL", "MSFT", "AMZN", "TSLA"]

    records = []
    for ticker in tickers:
        

        resp = client.get_previous_close_agg(ticker)
        ts = datetime.fromtimestamp(resp[0].timestamp/1000).strftime("%Y-%m-%d")
        data = {"ticker":resp[0].ticker,
                "close":resp[0].close,
                "high":resp[0].high,
                "low":resp[0].low,
                "open":resp[0].open,
                "date":ts,
                "volume":resp[0].volume,
                "vwap":resp[0].vwap
                }
        
        records.append(data)


    df = pd.DataFrame(records)

    table = pa.Table.from_pandas(df, preserve_index=False)

    buffer = BytesIO()
    pq.write_table(table, buffer)

    KEY = f"daily-stock-data/date={ts}/stocks.parquet"

    s3.put_object(
        Bucket=BUCKET,
        Key=KEY,
        Body=buffer.getvalue()
    )    
