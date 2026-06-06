import boto3

s3 = boto3.client('s3',  region_name='ap-south-1')
iam = boto3.client('iam', region_name='ap-south-1')
glue = boto3.client('glue', region_name='ap-south-1')

PROJECT = "stock-market-pipeline"
ENV = "dev"


class TestS3Buckets:

    def test_bronze_bucket_exists(self):
        response = s3.list_buckets()
        buckets = [b['Name'] for b in response['Buckets']]
        assert f"{PROJECT}-bronze-{ENV}" in buckets

    def test_silver_bucket_exists(self):
        response = s3.list_buckets()
        buckets = [b['Name'] for b in response['Buckets']]
        assert f"{PROJECT}-silver-{ENV}" in buckets

    def test_gold_bucket_exists(self):
        response = s3.list_buckets()
        buckets = [b['Name'] for b in response['Buckets']]
        assert f"{PROJECT}-gold-{ENV}" in buckets

    def test_bronze_bucket_is_private(self):
        response = s3.get_public_access_block(Bucket=f"{PROJECT}-bronze-{ENV}")
        config = response['PublicAccessBlockConfiguration']
        assert config['BlockPublicAcls']       
        assert config['BlockPublicPolicy']     
        assert config['IgnorePublicAcls']      
        assert config['RestrictPublicBuckets'] 

    def test_bronze_bucket_in_correct_region(self):
        response = s3.get_bucket_location(Bucket=f"{PROJECT}-bronze-{ENV}")
        assert response['LocationConstraint'] == 'ap-south-1'


class TestIAMRoles:

    def test_lambda_role_exists(self):
        response = iam.get_role(RoleName=f"{PROJECT}-lambda-role-{ENV}")
        assert response['Role']['RoleName'] == \
            f"{PROJECT}-lambda-role-{ENV}"

    def test_glue_role_exists(self):
        response = iam.get_role(RoleName=f"{PROJECT}-glue-role-{ENV}")
        assert response['Role']['RoleName'] == \
            f"{PROJECT}-glue-role-{ENV}"

    def test_lambda_role_has_correct_service(self):
        response = iam.get_role(
            RoleName=f"{PROJECT}-lambda-role-{ENV}"
        )
        policy = response['Role']['AssumeRolePolicyDocument']
        services = [
            s['Principal']['Service']
            for s in policy['Statement']
        ]
        assert 'lambda.amazonaws.com' in services

    def test_glue_role_has_correct_service(self):
        response = iam.get_role(
            RoleName=f"{PROJECT}-glue-role-{ENV}"
        )
        policy = response['Role']['AssumeRolePolicyDocument']
        services = [
            s['Principal']['Service']
            for s in policy['Statement']
        ]
        assert 'glue.amazonaws.com' in services


class TestGlueResources:

    def test_glue_database_exists(self):
        response = glue.get_database(
            Name=f"{PROJECT}_{ENV}"
        )
        assert response['Database']['Name'] == \
            f"{PROJECT}_{ENV}"

    def test_bronze_to_silver_job_exists(self):
        response = glue.get_job(
            JobName=f"{PROJECT}-bronze-to-silver-{ENV}"
        )
        assert response['Job']['Name'] == \
            f"{PROJECT}-bronze-to-silver-{ENV}"

    def test_silver_to_gold_job_exists(self):
        response = glue.get_job(
            JobName=f"{PROJECT}-silver-to-gold-{ENV}"
        )
        assert response['Job']['Name'] == \
            f"{PROJECT}-silver-to-gold-{ENV}"

    def test_bronze_crawler_exists(self):
        response = glue.get_crawler(
            Name=f"{PROJECT}-bronze-crawler-{ENV}"
        )
        assert response['Crawler']['Name'] == \
            f"{PROJECT}-bronze-crawler-{ENV}"

    def test_silver_crawler_exists(self):
        response = glue.get_crawler(
            Name=f"{PROJECT}-silver-crawler-{ENV}"
        )
        assert response['Crawler']['Name'] == \
            f"{PROJECT}-silver-crawler-{ENV}"

    def test_gold_crawler_exists(self):
        response = glue.get_crawler(
            Name=f"{PROJECT}-gold-crawler-{ENV}"
        )
        assert response['Crawler']['Name'] == \
            f"{PROJECT}-gold-crawler-{ENV}"

    def test_glue_jobs_use_correct_role(self):
        response = glue.get_job(
            JobName=f"{PROJECT}-bronze-to-silver-{ENV}"
        )
        assert "glue-role" in response['Job']['Role']
