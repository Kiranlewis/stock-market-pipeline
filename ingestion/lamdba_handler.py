from producer import ingestion

def lambda_handler(event,context):
    tickers = event.get("tickers", ["AAPL"])
    api_key = "YOUR_API_KEY"

    key = ingestion(tickers, api_key)

    return {
        "statusCode": 200,
        "body": f"Written to {key}"
    }