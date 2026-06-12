from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'vaibhavi',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': False,
}

with DAG(
    dag_id='commerce_analytics_pipeline',
    default_args=default_args,
    description='dbt pipeline for commerce analytics on Snowflake',
    schedule='0 0 * * *',
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['dbt', 'snowflake', 'commerce_analytics'],
) as dag:

    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command='cd /Users/vaibhavishah/Desktop/commerce_analytics/commerce_analytics && conda run -n dbt-env dbt seed',
    )

    dbt_run_staging = BashOperator(
        task_id='dbt_run_staging',
        bash_command='cd /Users/vaibhavishah/Desktop/commerce_analytics/commerce_analytics && conda run -n dbt-env dbt run -s staging',
    )

    dbt_test_staging = BashOperator(
        task_id='dbt_test_staging',
        bash_command='cd /Users/vaibhavishah/Desktop/commerce_analytics/commerce_analytics && conda run -n dbt-env dbt test -s staging',
    )

    dbt_seed >> dbt_run_staging >> dbt_test_staging
