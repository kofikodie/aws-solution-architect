set-alarm:
	aws cloudwatch set-alarm-state --alarm-name "ec2-cpu-utilization-alarm" --state-value ALARM --state-reason "testing purposes"