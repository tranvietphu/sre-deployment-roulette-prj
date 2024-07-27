#!/bin/bash
function re_scale {
  echo "==== RE_SCALE start... ===="
  INC=1
  V1_PODS=$(kubectl get pods -n udacity | grep -c canary-v1)
  echo "V1_PODS: $V1_PODS"
  V2_PODS=$(kubectl get pods -n udacity | grep -c canary-v2)
  echo "V2_PODS: $V2_PODS"

  kubectl scale deployment canary-v2 --replicas=$((V2_PODS + $INC))
  kubectl scale deployment canary-v1 --replicas=$((V1_PODS - $INC))

  # Wait until deployment rollout of canary-v2 complete.
  ROLLOUT_V2_STATUS="kubectl rollout status deployment/canary-v2 -n udacity"
  until $ROLLOUT_V2_STATUS; do
    $ROLLOUT_V2_STATUS
    sleep 3
  done

  # Wait until deployment rollout of canary-v1 complete.
  ROLLOUT_V1_STATUS="kubectl rollout status deployment/canary-v1 -n udacity"
  until $ROLLOUT_V1_STATUS; do
    $ROLLOUT_V1_STATUS
    sleep 3
  done
  echo "==== RE_SCALE successful! ===="
}

# canary-v2 deployment
kubectl apply -f ../starter/apps/canary/index_v2_html.yml
sleep 3
kubectl apply -f ../starter/apps/canary/canary-v2.yml
sleep 3

# re_scale until canary-v1 pods <= canary-v2 pods:
while [ $(kubectl get pods -n udacity | grep -c canary-v1) -gt $(kubectl get pods -n udacity | grep -c canary-v2) ]
do
  re_scale
done

echo "Canary deployment of v2 successful"


