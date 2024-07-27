# green deployment
kubectl apply -f ../starter/apps/blue-green/green.yml

# Wait until deployment rollout of green complete.
ROLLOUT_STATUS="kubectl rollout status deployment/green -n udacity"
until $ROLLOUT_STATUS; do
$ROLLOUT_STATUS
sleep 3
done

echo "Blue-Green deployment successful!"