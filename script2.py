# One command lists the versions of the ECS task definition for the service created in step 1
response = client.list_task_definitions(
    familyPrefix='string',
    status='ACTIVE'|'INACTIVE'|'DELETE_IN_PROGRESS',
    sort='ASC'|'DESC',
    nextToken='string',
    maxResults=123
)