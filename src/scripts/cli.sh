# GET PARAMETERS
aws ssm get-parameters --names /app/db/url
# GET PARAMETERS WITH DECRYPTION
aws ssm get-parameters --names /app/db/password --with-decryption

# GET PARAMETERS BY PATH
aws ssm get-parameters-by-path --path /app/db/
# GET PARAMETERS BY PATH RECURSIVE
aws ssm get-parameters-by-path --path /app/ --recursive
# GET PARAMETERS BY PATH WITH DECRYPTION
aws ssm get-parameters-by-path --path /app/ --recursive --with-decryption