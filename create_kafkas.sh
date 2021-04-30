#!/bin/bash

NUM=$1
STORAGE_CLASS=gp2
KAFKA_CPU=1000m
KAFKA_MEM=1Gi
ZOOKEEPER_CPU=500m
ZOOKEEPER_MEM=1Gi
BATCH=$(openssl rand -base64 12 |  tr -dc A-Za-z0-9 | tr '[:upper:]' '[:lower:]')

for ((i=1;i<=${NUM};i++))
do
    NAME=foo-$(openssl rand -base64 12 |  tr -dc A-Za-z0-9 | tr '[:upper:]' '[:lower:]')

echo Creating ${NAME} ${BATCH}

oc apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
    kafka: "true"
    batch: ${BATCH}
  name: ${NAME}
spec:
---
apiVersion: v1
kind: Secret
metadata:
  name: ${NAME}-sso-cert
  namespace: ${NAME}
type: Opaque
data:
  keycloak.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUdSVENDQlMyZ0F3SUJBZ0lTQkw3dmFDa1pQT1Z3WGxhZU9EU1VWNWF4TUEwR0NTcUdTSWIzRFFFQkN3VUEKTURJeEN6QUpCZ05WQkFZVEFsVlRNUll3RkFZRFZRUUtFdzFNWlhRbmN5QkZibU55ZVhCME1Rc3dDUVlEVlFRRApFd0pTTXpBZUZ3MHlNVEEwTURreE1EQTRNVGRhRncweU1UQTNNRGd4TURBNE1UZGFNQ3N4S1RBbkJnTlZCQU1UCklHbGtaVzUwYVhSNUxtRndhUzV6ZEdGblpTNXZjR1Z1YzJocFpuUXVZMjl0TUlJQ0lqQU5CZ2txaGtpRzl3MEIKQVFFRkFBT0NBZzhBTUlJQ0NnS0NBZ0VBckFwa29DdHBaTDErKzVGK295Sm1nc003YVdWVWFKZHpFa3FmTzZNMApRRE82QnN0SlJjZDVJNGkwSlBobzBPeG5DdkNiUmlicG03K2U3RGtTakRZSU1TMW1FRGpkWnQvUmZwNnViMTN5CjQ1TFpYNFNUQkg0b3V6YmV1OHNxK2QwM3V3OEJaOU1HK21nTnR0bTNiQ3hCZUZ2ZWNxdEFUT0tQSWNXdzljemkKQkVZak4wNXRUb3pHTVBJU1B4S0gxdE1xcC9EcXc1c3pxUWdWWkRMWlZDdFR1YU5LeTZKa2xVMVF3V0thV0g3WQpUNjlpN2drVXdwY1plV0J2Yk9FNDVyUC9NN0U1YmxVQUpGR0xzQUp1M3ZUUGYwMjl1R2cvelJBK0VuelVwdFpjCm9naVM0OVVjczUxQ3RObWcyRG5WKzhuY2xqdWtaN3N2a0tManBaRzI2czFJVGtHMXk1TGd0bEVhRTQyUFM5TDEKQ1VHbG80bm1PdWF6NG1vR29sQXZ3dWpLV3hhTWR2d09NQkF2WTd0Ylp4YlpaeFQ4WlVCNkRpY2YzRTZyQk9mQgpGL01UbFZXb0c3VVJ1c1JJOU1XcDdZV2ZZbVlxZWFvZHZjY1VrUjR5d1NtRzl4b1hpRld0cG82ZkpVRHVkZmRkCmh2VlBRUjM5OCthM1VNQU41NVlGUm1qRG80VjN0UGJNc0lwamp3VXU0TXFtaTVpbnFpVWhlMlFPVStQOHdUUmMKRnZOZ1ZTS2VqbVpQWksrSzUxV01QZmhyRTAvVTgyNlhkMlBVUExXV2FOaUNUWTFtMnZFZEFpUThvd3FKZU9FWgpqYnFIa1J3VEZxWHVvRTFCNEYwM2tUSFVwZ01FV1E5NW5QOWpRZzlMeDljYWxrR0ZsY0ZVcDdLbmRJWHMzODg0CnJvRUNBd0VBQWFPQ0Fsb3dnZ0pXTUE0R0ExVWREd0VCL3dRRUF3SUZvREFkQmdOVkhTVUVGakFVQmdnckJnRUYKQlFjREFRWUlLd1lCQlFVSEF3SXdEQVlEVlIwVEFRSC9CQUl3QURBZEJnTlZIUTRFRmdRVWhrKzVjNHpnSzBTTQpHMnkxTnhRWm9yMjdwSm93SHdZRFZSMGpCQmd3Rm9BVUZDNnpGN2RZVnN1dVVBbEE1aCt2bllzVXdzWXdWUVlJCkt3WUJCUVVIQVFFRVNUQkhNQ0VHQ0NzR0FRVUZCekFCaGhWb2RIUndPaTh2Y2pNdWJ5NXNaVzVqY2k1dmNtY3cKSWdZSUt3WUJCUVVITUFLR0ZtaDBkSEE2THk5eU15NXBMbXhsYm1OeUxtOXlaeTh3S3dZRFZSMFJCQ1F3SW9JZwphV1JsYm5ScGRIa3VZWEJwTG5OMFlXZGxMbTl3Wlc1emFHbG1kQzVqYjIwd1RBWURWUjBnQkVVd1F6QUlCZ1puCmdRd0JBZ0V3TndZTEt3WUJCQUdDM3hNQkFRRXdLREFtQmdnckJnRUZCUWNDQVJZYWFIUjBjRG92TDJOd2N5NXMKWlhSelpXNWpjbmx3ZEM1dmNtY3dnZ0VEQmdvckJnRUVBZFo1QWdRQ0JJSDBCSUh4QU84QWRRQkVsR1V1c083TwpyOFJBQjlpby9pakEydWFDdnRqTE1iVS8wek9XdGJhQnFBQUFBWGkyVVgvb0FBQUVBd0JHTUVRQ0lIcmZSZHRVCnBWQWF4dENYSGhaRXUyZVNJS0kyMjhCUldMcFBZclM0eEljNEFpQnErOTNqKzRNNHNCc0dvRTdVSnMwdzllZHcKb2t3bzY5bUlmY01ETWsxd2FnQjJBSDArOHZpUC80aFZhQ1RDd01xZVVvbDVLOFVPZUFsL0xtcVhhSmwrSXZEWApBQUFCZUxaUmdBb0FBQVFEQUVjd1JRSWhBT1hzU3pxdVVod0p4dmJUWGNwRzBPZlJpM3pjY2tJNU5IWUZxQmhOClEydDRBaUFpNm9Xd3ZiRFcvOWdiMmdSM1BxcCtaOUtIOUM3aFRpTDlBSm1iVCttdE9UQU5CZ2txaGtpRzl3MEIKQVFzRkFBT0NBUUVBUjYyVjhHZTAzejJKbzUyUFlSdnRvVGZmWDlNWnFxbTl0NUYycFkrOTg2dGN2OFF0MFpMRAorNElJanZwQ1U1bGtNZlljaDR3MnA3M05ZV1pScWhaSFRyYlV6ZkhpNWp6VXAwaURCSklPTm1qNkErNFY2cC9JClJMRU0rYTNpV1I0K1BsTXZmQTRHM0g0ZGNxeEJkVTUyUi9WZmpxdTVMUTZVV0VDWnBWcXp2L2hsaElLTTU3UmgKbjRFZzB3bXRoekl6bE8yMkJYdGl5TSs0ZnUyQUtmMC83SjZ2b0R6bElxOG1ZWlc2OWcrRkZWNmE4cVV2U0FNLwplSC9aQUNEWkpIdnhhMTBMckk4NEY2Y1l3Tm5MZ0xyMG1LTlM1RmplTURUMDNaU3lSd2U0UysxQTlLMDNrTy96CkZ0Z1puUkhmS1duVkdMam5BQVJhNkJuOEprYzgwWjdKdGc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCi0tLS0tQkVHSU4gQ0VSVElGSUNBVEUtLS0tLQpNSUlHUlRDQ0JTMmdBd0lCQWdJU0JMN3ZhQ2taUE9Wd1hsYWVPRFNVVjVheE1BMEdDU3FHU0liM0RRRUJDd1VBCk1ESXhDekFKQmdOVkJBWVRBbFZUTVJZd0ZBWURWUVFLRXcxTVpYUW5jeUJGYm1OeWVYQjBNUXN3Q1FZRFZRUUQKRXdKU016QWVGdzB5TVRBME1Ea3hNREE0TVRkYUZ3MHlNVEEzTURneE1EQTRNVGRhTUNzeEtUQW5CZ05WQkFNVApJR2xrWlc1MGFYUjVMbUZ3YVM1emRHRm5aUzV2Y0dWdWMyaHBablF1WTI5dE1JSUNJakFOQmdrcWhraUc5dzBCCkFRRUZBQU9DQWc4QU1JSUNDZ0tDQWdFQXJBcGtvQ3RwWkwxKys1RitveUptZ3NNN2FXVlVhSmR6RWtxZk82TTAKUURPNkJzdEpSY2Q1STRpMEpQaG8wT3huQ3ZDYlJpYnBtNytlN0RrU2pEWUlNUzFtRURqZFp0L1JmcDZ1YjEzeQo0NUxaWDRTVEJING91emJldThzcStkMDN1dzhCWjlNRyttZ050dG0zYkN4QmVGdmVjcXRBVE9LUEljV3c5Y3ppCkJFWWpOMDV0VG96R01QSVNQeEtIMXRNcXAvRHF3NXN6cVFnVlpETFpWQ3RUdWFOS3k2SmtsVTFRd1dLYVdIN1kKVDY5aTdna1V3cGNaZVdCdmJPRTQ1clAvTTdFNWJsVUFKRkdMc0FKdTN2VFBmMDI5dUdnL3pSQStFbnpVcHRaYwpvZ2lTNDlVY3M1MUN0Tm1nMkRuVis4bmNsanVrWjdzdmtLTGpwWkcyNnMxSVRrRzF5NUxndGxFYUU0MlBTOUwxCkNVR2xvNG5tT3VhejRtb0dvbEF2d3VqS1d4YU1kdndPTUJBdlk3dGJaeGJaWnhUOFpVQjZEaWNmM0U2ckJPZkIKRi9NVGxWV29HN1VSdXNSSTlNV3A3WVdmWW1ZcWVhb2R2Y2NVa1I0eXdTbUc5eG9YaUZXdHBvNmZKVUR1ZGZkZApodlZQUVIzOTgrYTNVTUFONTVZRlJtakRvNFYzdFBiTXNJcGpqd1V1NE1xbWk1aW5xaVVoZTJRT1UrUDh3VFJjCkZ2TmdWU0tlam1aUFpLK0s1MVdNUGZockUwL1U4MjZYZDJQVVBMV1dhTmlDVFkxbTJ2RWRBaVE4b3dxSmVPRVoKamJxSGtSd1RGcVh1b0UxQjRGMDNrVEhVcGdNRVdROTVuUDlqUWc5THg5Y2Fsa0dGbGNGVXA3S25kSVhzMzg4NApyb0VDQXdFQUFhT0NBbG93Z2dKV01BNEdBMVVkRHdFQi93UUVBd0lGb0RBZEJnTlZIU1VFRmpBVUJnZ3JCZ0VGCkJRY0RBUVlJS3dZQkJRVUhBd0l3REFZRFZSMFRBUUgvQkFJd0FEQWRCZ05WSFE0RUZnUVVoays1YzR6Z0swU00KRzJ5MU54UVpvcjI3cEpvd0h3WURWUjBqQkJnd0ZvQVVGQzZ6RjdkWVZzdXVVQWxBNWgrdm5Zc1V3c1l3VlFZSQpLd1lCQlFVSEFRRUVTVEJITUNFR0NDc0dBUVVGQnpBQmhoVm9kSFJ3T2k4dmNqTXVieTVzWlc1amNpNXZjbWN3CklnWUlLd1lCQlFVSE1BS0dGbWgwZEhBNkx5OXlNeTVwTG14bGJtTnlMbTl5Wnk4d0t3WURWUjBSQkNRd0lvSWcKYVdSbGJuUnBkSGt1WVhCcExuTjBZV2RsTG05d1pXNXphR2xtZEM1amIyMHdUQVlEVlIwZ0JFVXdRekFJQmdabgpnUXdCQWdFd053WUxLd1lCQkFHQzN4TUJBUUV3S0RBbUJnZ3JCZ0VGQlFjQ0FSWWFhSFIwY0RvdkwyTndjeTVzClpYUnpaVzVqY25sd2RDNXZjbWN3Z2dFREJnb3JCZ0VFQWRaNUFnUUNCSUgwQklIeEFPOEFkUUJFbEdVdXNPN08KcjhSQUI5aW8vaWpBMnVhQ3Z0akxNYlUvMHpPV3RiYUJxQUFBQVhpMlVYL29BQUFFQXdCR01FUUNJSHJmUmR0VQpwVkFheHRDWEhoWkV1MmVTSUtJMjI4QlJXTHBQWXJTNHhJYzRBaUJxKzkzais0TTRzQnNHb0U3VUpzMHc5ZWR3Cm9rd282OW1JZmNNRE1rMXdhZ0IyQUgwKzh2aVAvNGhWYUNUQ3dNcWVVb2w1SzhVT2VBbC9MbXFYYUpsK0l2RFgKQUFBQmVMWlJnQW9BQUFRREFFY3dSUUloQU9Yc1N6cXVVaHdKeHZiVFhjcEcwT2ZSaTN6Y2NrSTVOSFlGcUJoTgpRMnQ0QWlBaTZvV3d2YkRXLzlnYjJnUjNQcXArWjlLSDlDN2hUaUw5QUptYlQrbXRPVEFOQmdrcWhraUc5dzBCCkFRc0ZBQU9DQVFFQVI2MlY4R2UwM3oySm81MlBZUnZ0b1RmZlg5TVpxcW05dDVGMnBZKzk4NnRjdjhRdDBaTEQKKzRJSWp2cENVNWxrTWZZY2g0dzJwNzNOWVdaUnFoWkhUcmJVemZIaTVqelVwMGlEQkpJT05tajZBKzRWNnAvSQpSTEVNK2EzaVdSNCtQbE12ZkE0RzNINGRjcXhCZFU1MlIvVmZqcXU1TFE2VVdFQ1pwVnF6di9obGhJS001N1JoCm40RWcwd210aHpJemxPMjJCWHRpeU0rNGZ1MkFLZjAvN0o2dm9EemxJcThtWVpXNjlnK0ZGVjZhOHFVdlNBTS8KZUgvWkFDRFpKSHZ4YTEwTHJJODRGNmNZd05uTGdMcjBtS05TNUZqZU1EVDAzWlN5UndlNFMrMUE5SzAza08vegpGdGdablJIZktXblZHTGpuQUFSYTZCbjhKa2M4MFo3SnRnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ==
---
apiVersion: v1
data:
  ssoClientSecret: MzE0MzJmZmYtZDdhMS00NjQ2LTg3MWMtNTk3NTA1ZjRjNjky
kind: Secret
metadata:
  name: ${NAME}-sso-secret
  namespace: ${NAME}
type: Opaque
---

apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUdVRENDQlRpZ0F3SUJBZ0lRQ29nWWNKR2I3M0d1Zlp4aG5SNi9nREFOQmdrcWhraUc5dzBCQVFzRkFEQlAKTVFzd0NRWURWUVFHRXdKVlV6RVZNQk1HQTFVRUNoTU1SR2xuYVVObGNuUWdTVzVqTVNrd0p3WURWUVFERXlCRQphV2RwUTJWeWRDQlVURk1nVWxOQklGTklRVEkxTmlBeU1ESXdJRU5CTVRBZUZ3MHlNREV5TURNd01EQXdNREJhCkZ3MHlNVEV5TURjeU16VTVOVGxhTUc4eEN6QUpCZ05WQkFZVEFsVlRNUmN3RlFZRFZRUUlFdzVPYjNKMGFDQkQKWVhKdmJHbHVZVEVRTUE0R0ExVUVCeE1IVW1Gc1pXbG5hREVXTUJRR0ExVUVDaE1OVW1Wa0lFaGhkQ3dnU1c1agpMakVkTUJzR0ExVUVBd3dVS2k1cllXWnJZUzVrWlhaemFHbG1kQzV2Y21jd2dnRWlNQTBHQ1NxR1NJYjNEUUVCCkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDcVpPa0NTY2lKR2dXMlowSGNrZnlxNEIzT0tIU1RORldGeDFxQklNM3IKdStzeFRzNHU2SHdxT1NNNzlqK2VNdXVmdHcrMzZxZFBiT1JzQjN4dU9mdTNBbFlyVWpGaGpDWFhjQ2Nkc3NGSwpMNENjaU53Zi9JcGt2bkZ6RGdXSG5ac3puZWIwa1NCTHpQaW5aeGtsakhPTWFEMnp2SnlNSDllUDFycDJzNWhTCk9LZGpSOVZzVUZ6UVovcHRKUjVTdDIyTFY5MjVNanZIblVXUzBPdkxlMEFQQkJTYnMzaytMSENvcmpmbDladWIKMGZGNjluYWJTd1M3YzJaSzgwc2c3YlFtNXBDTTNGRXZtenpXT3IzcnlOUkZPV0dGNGpaeUNmdnY2bVFNTVBHZQo2b0JKRkZKczh2QWlyMVJyZ2I1MHZ4QWdwc3NwVnlZVGdsTlkxSlZCSXBwOUFnTUJBQUdqZ2dNR01JSURBakFmCkJnTlZIU01FR0RBV2dCUzNhNkxxcUtxRWpIbnF0Tm9QbUxMRmxYYTU5REFkQmdOVkhRNEVGZ1FVRVRXN2VpRm0KMDNMWlIzaFBicUdVK0loZ1Rud3dId1lEVlIwUkJCZ3dGb0lVS2k1cllXWnJZUzVrWlhaemFHbG1kQzV2Y21jdwpEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHQVFVRkJ3TUJCZ2dyQmdFRkJRY0RBakNCCml3WURWUjBmQklHRE1JR0FNRDZnUEtBNmhqaG9kSFJ3T2k4dlkzSnNNeTVrYVdkcFkyVnlkQzVqYjIwdlJHbG4KYVVObGNuUlVURk5TVTBGVFNFRXlOVFl5TURJd1EwRXhMbU55YkRBK29EeWdPb1k0YUhSMGNEb3ZMMk55YkRRdQpaR2xuYVdObGNuUXVZMjl0TDBScFoybERaWEowVkV4VFVsTkJVMGhCTWpVMk1qQXlNRU5CTVM1amNtd3dUQVlEClZSMGdCRVV3UXpBM0JnbGdoa2dCaHYxc0FRRXdLakFvQmdnckJnRUZCUWNDQVJZY2FIUjBjSE02THk5M2QzY3UKWkdsbmFXTmxjblF1WTI5dEwwTlFVekFJQmdabmdRd0JBZ0l3ZlFZSUt3WUJCUVVIQVFFRWNUQnZNQ1FHQ0NzRwpBUVVGQnpBQmhoaG9kSFJ3T2k4dmIyTnpjQzVrYVdkcFkyVnlkQzVqYjIwd1J3WUlLd1lCQlFVSE1BS0dPMmgwCmRIQTZMeTlqWVdObGNuUnpMbVJwWjJsalpYSjBMbU52YlM5RWFXZHBRMlZ5ZEZSTVUxSlRRVk5JUVRJMU5qSXcKTWpCRFFURXVZM0owTUF3R0ExVWRFd0VCL3dRQ01BQXdnZ0VGQmdvckJnRUVBZFo1QWdRQ0JJSDJCSUh6QVBFQQpkZ0QyWEpRdjBYY3dJaFJVR0Fnd2xGYU80MDBUR1RPLzN3d3ZJQXZNVHZGazR3QUFBWFlwTUowc0FBQUVBd0JICk1FVUNJQjlFY09rT1Iyc2NGeEQvNDNnZzNteGZCWENGeU1uVS9IRGQ0QWtsVlhVWEFpRUEzM2JpRzlhcWhWUXAKdk1QUjZ5a29uNVhuR1ltQ3llbSs3SEpWbXBXSnZ2NEFkd0JjM0VPUy91YXJSVVN4WHByVVZ1WVFOL3ZWK2tmYwpvWE9Vc2w3bTlzY095Z0FBQVhZcE1KMktBQUFFQXdCSU1FWUNJUURaQnRIcXR3QXJGNVhJL2JaK0ZkaDQ0R2lLCk1tdldOa003cWNEYjZRbU9uQUloQU45NlYybWhTUmdURTBHQ1ZFS3dkRzVGK2djWThMZmpUcFNKR05CUG9aK0wKTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFDN3BqOHVCRjB1RDZYWUMvM3ZTRWdsMlM3a2h6NUlqVWNtTWFIRgpOa3lYeTF2UVBXUzh2QzNodUNXemNYSTFvMTdiaDhxWE0xWDlSS0VJeGxEMDk2eHhsOTQrRmUxWnZKSTFWcjRLCk40MCs1c1FUd1FaN0ROMG1jamRTZkFPUy9pOHhlWVRSSzNjc0NWRVZqclVtTDUzSXNPbHJXbTdXWWlMZ2krTnEKaFh0MjRkci9kMWErQno0QzhLcHZlbWY5cEZQb3dLdVN6Y0RvbGVtNUVNN1pENGFDRURVMElHUmhVTGxLdkFiaQpaRGFJaWRsbHlqUHJpR24wRE42WFR6d3JCaHRFaC9LeERqZk85ZnFXR2ZRNWQyZnlDRlBCdWZyenY2aWlCVkQ4CmhBVXZnU0dCZ1ZXZExYekd4QjIyNGZxWTRma28yV2RoZittS0VBSzRRMFg2b2pJbwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCi0tLS0tQkVHSU4gQ0VSVElGSUNBVEUtLS0tLQpNSUlFNmpDQ0E5S2dBd0lCQWdJUUNqVUkxVndwS3dGOStLMWx3QS8zNURBTkJna3Foa2lHOXcwQkFRc0ZBREJoCk1Rc3dDUVlEVlFRR0V3SlZVekVWTUJNR0ExVUVDaE1NUkdsbmFVTmxjblFnU1c1ak1Sa3dGd1lEVlFRTEV4QjMKZDNjdVpHbG5hV05sY25RdVkyOXRNU0F3SGdZRFZRUURFeGRFYVdkcFEyVnlkQ0JIYkc5aVlXd2dVbTl2ZENCRApRVEFlRncweU1EQTVNalF3TURBd01EQmFGdzB6TURBNU1qTXlNelU1TlRsYU1FOHhDekFKQmdOVkJBWVRBbFZUCk1SVXdFd1lEVlFRS0V3eEVhV2RwUTJWeWRDQkpibU14S1RBbkJnTlZCQU1USUVScFoybERaWEowSUZSTVV5QlMKVTBFZ1UwaEJNalUySURJd01qQWdRMEV4TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQwpBUUVBd1V1elpVZHd2TjFQV052c25PM0RadVVmTVJOVXJVcG1SaDhzQ3V4a0IrVXUzTnk1Q2lEdDMrUEUwSjZhCnFYb2Rnb2psRVZiYkhwOVl3bEhuTERRTkx0S1M0VmJMOFhsZnM3dUh5aVVEZTVwU1FXWVFZRTlYRTBudzZEZG4KZzkvbjAwdG5UQ0pScHQ4T21SRHRWMUYwSnVKOXg4cGlMaE1iZnlPSUpWTnZ3VFJZQUl1RS8vaStwMWhKSW51VwpyYUtJbXhXOG9IemY2VkdvMWJEdE4rSTJ0SUpMWXJWSm11ekhaOWJqUHZYajFoSmVSUEcvY1VKOVdJUURnTEdCCkFmcjV5aks3dEk0bmh5ZkZLM1RVcU5hWDNzTmsrY3JPVTZKV3ZIZ1hqa2tES2E3N1NVK2tGYm5POGx3WlYyMXIKZWFjcm9pY2dFN1hRUFVEVElUQUhrK3FaOVFJREFRQUJvNElCcmpDQ0Fhb3dIUVlEVlIwT0JCWUVGTGRyb3Vxbwpxb1NNZWVxMDJnK1lzc1dWZHJuME1COEdBMVVkSXdRWU1CYUFGQVBlVURWVzBVeTdadkNqNGhzYnc1ZXlQZEZWCk1BNEdBMVVkRHdFQi93UUVBd0lCaGpBZEJnTlZIU1VFRmpBVUJnZ3JCZ0VGQlFjREFRWUlLd1lCQlFVSEF3SXcKRWdZRFZSMFRBUUgvQkFnd0JnRUIvd0lCQURCMkJnZ3JCZ0VGQlFjQkFRUnFNR2d3SkFZSUt3WUJCUVVITUFHRwpHR2gwZEhBNkx5OXZZM053TG1ScFoybGpaWEowTG1OdmJUQkFCZ2dyQmdFRkJRY3dBb1kwYUhSMGNEb3ZMMk5oClkyVnlkSE11WkdsbmFXTmxjblF1WTI5dEwwUnBaMmxEWlhKMFIyeHZZbUZzVW05dmRFTkJMbU55ZERCN0JnTlYKSFI4RWREQnlNRGVnTmFBemhqRm9kSFJ3T2k4dlkzSnNNeTVrYVdkcFkyVnlkQzVqYjIwdlJHbG5hVU5sY25SSApiRzlpWVd4U2IyOTBRMEV1WTNKc01EZWdOYUF6aGpGb2RIUndPaTh2WTNKc05DNWthV2RwWTJWeWRDNWpiMjB2ClJHbG5hVU5sY25SSGJHOWlZV3hTYjI5MFEwRXVZM0pzTURBR0ExVWRJQVFwTUNjd0J3WUZaNEVNQVFFd0NBWUcKWjRFTUFRSUJNQWdHQm1lQkRBRUNBakFJQmdabmdRd0JBZ013RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUhlcgp0M29uUGE2NzluL2dXbGJKaEtyS1czRVgzU0pIL0U2Zjd0REJwQVRobyt2RlNjSDkwY25maksrVVJTeEdLcU5qCk9TRDVua29rbEVISXFkbmluRlFGQnN0Y0hMNEFHdytvV3Y4WnUyWEhGcThoVnQxaEJjbnBqNWgyMzJzYjBISU0KVUxrd0tYcS9ZRmtRWmhNNkxhd1ZFV3d0SXd3Q1BnVTcvdVdobk9LSzI0ZlhTdWhlNTBnRzY2c1Ntdkt2aE1OYgpnMHFaZ1lPckFLSEtDanhNb2lXSktpS25wUE16VEZ1TUxob0NsdytkajIwdGxRajdUOXJ4a1RnbDRaeHVZUmlICmFzNnh1d0F3YXB1M3I5cnh4WmYraW5na3F1cVRnTG96WlhxOG9YZnBmMmtVQ3dBL2Q1S3hUVnR6aHdvVDBKekkKOGtzNVQxS0VTYVpNa0U0Zjk3UT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ==
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRQ3FaT2tDU2NpSkdnVzIKWjBIY2tmeXE0QjNPS0hTVE5GV0Z4MXFCSU0zcnUrc3hUczR1Nkh3cU9TTTc5aitlTXV1ZnR3KzM2cWRQYk9ScwpCM3h1T2Z1M0FsWXJVakZoakNYWGNDY2Rzc0ZLTDRDY2lOd2YvSXBrdm5GekRnV0huWnN6bmViMGtTQkx6UGluClp4a2xqSE9NYUQyenZKeU1IOWVQMXJwMnM1aFNPS2RqUjlWc1VGelFaL3B0SlI1U3QyMkxWOTI1TWp2SG5VV1MKME92TGUwQVBCQlNiczNrK0xIQ29yamZsOVp1YjBmRjY5bmFiU3dTN2MyWks4MHNnN2JRbTVwQ00zRkV2bXp6VwpPcjNyeU5SRk9XR0Y0alp5Q2Z2djZtUU1NUEdlNm9CSkZGSnM4dkFpcjFScmdiNTB2eEFncHNzcFZ5WVRnbE5ZCjFKVkJJcHA5QWdNQkFBRUNnZ0VBQVJJNVZNWlorR0t0Zm9RUHFlOVJBMUg5WGZwcklUSEhCOXhFK1dMWGFJLzUKM29sOFNsY3owS0FqVkpFcnZUYmN2RmhPUlAyNHA0c3J0SElubWhuTE4wOVFjMTFFNmpRVFdOTmZxNVFnR3ZOSgpmN0pzajlicWw4K0tyd3A3aG1xN093dlhFOXFGdFhSSWErVCtCM3BtajQ5b00rVVBwdUhjWFE4Z2hQYUVFcUE5CjdBOFJXZ09GdzdNbFp1T1dmTHBMei9EaG54cFBkMHRzbkd5WTgyL1RBaEhoMytTR1ZsM3BoQVBQcGlHejE1VEsKbk54TzJMMFZpMnRHMDVSdjlybDhETUNZVktaMk1UWkdJckpGNXRwL0RzZElVcUJJOEdZNWR6aUE0cFBiMmpKSApjRFF0TmhMc1RFckt2SHltUWxqZlUvRm1jVzBMU0lDN1FmUTYzM3Via1FLQmdRRGJoREl1SHBBaDh3Nk9HTE4zCmh6VVdBejRvSkdPSk9IYllhbHpmVkxqUXlsR2tUazlGOWRhdDI5eVdNTSt0b0NCcGFsS3kzTnV2ZHQxdFAzU0sKNXB4TE5Kb1lJRytiZ1BpVkJrSVo1WGtHWjBZVlN0TUlJNVJLRTNkS0hwUHRGb0pmTmY1NUpHRjJwaWZScHo5LwpJck5MaW5USkRpV2dHekIrTGZmTytSVU5Yd0tCZ1FER3RyUFlWeVpGU2lTTFlFR1N0eU9QVG9FZ2R3WkVNK0RrCmpacjJFdHhCV29NLytlR1Nhdm5mYll3L2tZTW1XYjhVdFZsaUtWb0g2QjFHemRFTnpBOFFrUGRLNlhKbVdkZEIKVG5tREE1UTFkcGZsSkZBU2lxRkdGdUJsRC9KL2h4VVlFMU1hL2V2MlB2VjVSZUlZTFUzVmVtYzBpMXRWeVJaVQp2ZEpScFBWSm93S0JnRVA4KzdYQkRZOFdRcW5NQ0xtNmpMeVdvSWU2VFlIUWxTNk9NdG1RMmZVQTFLeDQvS0NFCmRjcy9UMkROR1dXRE5NYXhnWStZVEFwYVhGWmIwdks2WGlvRXpyMHVQcU1CSFB5N0JYb1QwcG9qSGxlMTV3cWMKU205dS9BRmUyeDRSWEt1MGcyNXQwQ241YUZmTTN5TzNVYVRSNnozaVBkRUsyc2daNEtpZ0NOOHRBb0dBUGU0cApCTTY4YmJIYXk5bFc5bXUvV0dWbUZ3RWhZZFl0UyszYUVzRDBCaVk0YTVMc08xNjl1MlYvNVR2cmZPTlJpeG10CjNzcjJkU3BoSFhUOXAyZ21kY3BJVi8rRG1PUjlFcXhyY0dxSUlWVnhwNGQyc1NDbGZKdWFtY1NybGhVNmZNTmgKRGpOKys4TEpiRjljUko2eCtFdHFxTlNaeFpXak1RdnI1V2djempNQ2dZRUF0TDhaUVY4MFl1U3NGaHkxWU1mYgpaWU1VaTJnRzQxdWV6Yno3dTc5MS9JcUNpNDBqNE1ZYWN1eVNoazB4Q3FZMEJaVG5teWo0QTc3bGJlUU43SVl2ClJYNXVQaEtxblRzTW1uQksvZEVTVUpwcVY3RTZ5bkY2S3BJSXZkSGJjNU41UmtzaTZva21QTjZUMUJDWW1VMk0KWlJCUjVuUDJCNmlHWVlCdmkxYTRyOE09Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0=
kind: Secret
metadata:
  name: ${NAME}-tls-secret
  namespace: ${NAME}
type: kubernetes.io/tls
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${NAME}-kafka-metrics
  namespace: ${NAME}
data:
  jmx-exporter-config: |
    lowercaseOutputName: true
    rules:
      - labels:
          clientID: $$3
          partition: $$5
          topic: $$4
        name: kafka_server_$$1_$$2
        pattern: >-
          kafka.server<type=(.+), name=(.+), clientId=(.+), topic=(.+),
          partition=(.*)><>Value
        type: GAUGE
      - labels:
          broker: '$$4:$$5'
          clientId: $$3
        name: kafka_server_$$1_$$2
        pattern: >-
          kafka.server<type=(.+), name=(.+), clientId=(.+), brokerHost=(.+),
          brokerPort=(.+)><>Value
        type: GAUGE
      - labels:
          cipher: $$5
          listener: $$2
          networkProcessor: $$3
          protocol: $$4
        name: kafka_server_$$1_connections_tls_info
        pattern: >-
          kafka.server<type=(.+), cipher=(.+), protocol=(.+), listener=(.+),
          networkProcessor=(.+)><>connections
        type: GAUGE
      - labels:
          clientSoftwareName: $$2
          clientSoftwareVersion: $$3
          listener: $$4
          networkProcessor: $$5
        name: kafka_server_$$1_connections_software
        pattern: >-
          kafka.server<type=(.+), clientSoftwareName=(.+),
          clientSoftwareVersion=(.+), listener=(.+),
          networkProcessor=(.+)><>connections
        type: GAUGE
      - labels:
          listener: $$2
          networkProcessor: $$3
        name: kafka_server_$$1_$$4
        pattern: 'kafka.server<type=(.+), listener=(.+), networkProcessor=(.+)><>(.+):'
        type: GAUGE
      - labels:
          listener: $$2
          networkProcessor: $$3
        name: kafka_server_$$1_$$4
        pattern: 'kafka.server<type=(.+), listener=(.+), networkProcessor=(.+)><>(.+)'
        type: GAUGE
      - name: kafka_controller_kafkacontroller_offline_partitions_count
        pattern: >-
          kafka.controller<type=KafkaController,
          name=OfflinePartitionsCount><>Value
        type: GAUGE
      - name: kafka_server_replicamanager_under_replicated_partitions
        pattern: >-
          kafka.server<type=ReplicaManager,
          name=UnderReplicatedPartitions><>Value
        type: GAUGE
      - name: kafka_server_replicamanager_at_min_isr_partition_count
        pattern: >-
          kafka.server<type=ReplicaManager,
          name=AtMinIsrPartitionCount><>Value
        type: GAUGE
      - labels:
          partition: $$2
          topic: $$1
        name: kafka_cluster_partition_at_min_isr
        pattern: >-
          kafka.cluster<type=Partition, name=AtMinIsr, topic=(.+),
          partition=(.*)><>Value
        type: GAUGE
      - name: kafka_server_replicamanager_under_min_isr_partition_count
        pattern: >-
          kafka.server<type=ReplicaManager,
          name=UnderMinIsrPartitionCount><>Value
        type: GAUGE
      - labels:
          partition: $$2
          topic: $$1
        name: kafka_cluster_partition_under_min_isr
        pattern: >-
          kafka.cluster<type=Partition, name=UnderMinIsr, topic=(.+),
          partition=(.*)><>Value
        type: GAUGE
      - name: kafka_controller_kafkacontroller_active_controller_count
        pattern: >-
          kafka.controller<type=KafkaController,
          name=ActiveControllerCount><>Value
        type: GAUGE
      - name: kafka_server_replicamanager_leader_count
        pattern: 'kafka.server<type=ReplicaManager, name=LeaderCount><>Value'
        type: GAUGE
      - labels:
          topic: $$1
        name: kafka_server_brokertopicmetrics_bytes_in_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics, name=BytesInPerSec,
          topic=(.+)><>Count
        type: GAUGE
      - labels:
          topic: $$1
        name: kafka_server_brokertopicmetrics_bytes_out_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics, name=BytesOutPerSec,
          topic=(.+)><>Count
        type: GAUGE
      - labels:
          topic: $$1
        name: kafka_server_brokertopicmetrics_messages_in_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics, name=MessagesInPerSec,
          topic=(.+)><>Count
        type: GAUGE
      - name: kafka_controller_kafkacontroller_global_partition_count
        pattern: >-
          kafka.controller<type=KafkaController,
          name=GlobalPartitionCount><>Value
        type: GAUGE
      - labels:
          partition: $$2
          topic: $$1
        name: kafka_log_log_size
        pattern: 'kafka.log<type=Log, name=Size, topic=(.+), partition=(.*)><>Value'
        type: GAUGE
      - name: kafka_log_logmanager_offline_log_directory_count
        pattern: 'kafka.log<type=LogManager, name=OfflineLogDirectoryCount><>Value'
        type: GAUGE
      - name: kafka_controller_controllerstats_unclean_leader_elections_total
        pattern: >-
          kafka.controller<type=ControllerStats,
          name=UncleanLeaderElectionsPerSec><>Count
        type: GAUGE
      - name: kafka_server_replicamanager_partition_count
        pattern: 'kafka.server<type=ReplicaManager, name=PartitionCount><>Value'
        type: GAUGE
      - labels:
          topic: $$1
        name: kafka_server_brokertopicmetrics_total_produce_requests_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics,
          name=TotalProduceRequestsPerSec, topic=(.+)><>Count
        type: COUNTER
      - name: kafka_server_brokertopicmetrics_failed_produce_requests_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics,
          name=FailedProduceRequestsPerSec><>Count
        type: COUNTER
      - labels:
          topic: $$1
        name: kafka_server_brokertopicmetrics_total_fetch_requests_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics, name=TotalFetchRequestsPerSec,
          topic=(.+)><>Count
        type: COUNTER
      - name: kafka_server_brokertopicmetrics_failed_fetch_requests_total
        pattern: >-
          kafka.server<type=BrokerTopicMetrics,
          name=FailedFetchRequestsPerSec><>Count
        type: COUNTER
      - name: kafka_network_socketserver_network_processor_avg_idle_percent
        pattern: >-
          kafka.network<type=SocketServer,
          name=NetworkProcessorAvgIdlePercent><>Value
        type: GAUGE
      - name: >-
          kafka_server_kafkarequesthandlerpool_request_handler_avg_idle_percent
        pattern: >-
          kafka.server<type=KafkaRequestHandlerPool,
          name=RequestHandlerAvgIdlePercent><>MeanRate
        type: GAUGE
      - labels:
          partition: $$2
          topic: $$1
        name: kafka_cluster_partition_replicas_count
        pattern: >-
          kafka.cluster<type=Partition, name=ReplicasCount, topic=(.+),
          partition=(.*)><>Value
        type: GAUGE
      - labels:
          $$1: $$2
          quantile: 0.$$3
        name: kafka_network_requestmetrics_total_time_ms
        pattern: >-
          kafka.network<type=RequestMetrics, name=TotalTimeMs,
          (.+)=(.+)><>(\d+)thPercentile
        type: GAUGE
      - pattern: kafka.server<type=socket-server-metrics, listener=(.+), networkProcessor=(.+)><>connection-count
        name: kafka_server_socket_listener_connection_count
        type: GAUGE
        labels:
          listener: "$$1"
          networkProcessor: "$$2"
      - pattern: kafka.server<type=socket-server-metrics, listener=(.+), networkProcessor=(.+)><>connection-creation-rate
        name: kafka_server_socket_listener_connection_creation_rate
        type: GAUGE
        labels:
          listener: "$$1"
          networkProcessor: "$$2"
      - pattern: kafka.server<type=socket-server-metrics><>broker-connection-accept-rate
        name: kafka_server_socket_broker_connection_accept_rate
        type: GAUGE
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${NAME}-zookeeper-metrics
  namespace: ${NAME}
data:
  jmx-exporter-config: |-
    lowercaseOutputName: true
    rules:
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_outstanding_requests
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+))><>OutstandingRequests
        type: GAUGE
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_avg_request_latency
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+))><>AvgRequestLatency
        type: GAUGE
      - name: zookeeper_quorum_size
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+))><>QuorumSize
        type: GAUGE
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_num_alive_connections
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+))><>NumAliveConnections
        type: GAUGE
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_in_memory_data_tree_node_count
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+),
          name3=InMemoryDataTree)><>NodeCount
        type: GAUGE
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_in_memory_data_tree_watch_count
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+),
          name3=InMemoryDataTree)><>WatchCount
        type: GAUGE
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_min_request_latency
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+))><>MinRequestLatency
        type: GAUGE
      - labels:
          memberType: $$3
          replicaId: $$2
        name: zookeeper_max_request_latency
        pattern: >-
          org.apache.ZooKeeperService<(name0=ReplicatedServer_id(\d+),
          name1=replica.(\d+), name2=(\w+))><>MaxRequestLatency
        type: GAUGE
---
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: ${NAME}
  namespace: ${NAME}
  labels:
    kafka: "true"
    batch: ${BATCH}
spec:
  kafka:
    authorization:
      authorizerClass: io.bf2.kafka.authorizer.GlobalAclAuthorizer
      type: custom
    config:
      auto.create.topics.enable: "false"
      client.quota.callback.class: org.apache.kafka.server.quota.StaticQuotaCallback
      client.quota.callback.static.consume: "699050"
      client.quota.callback.static.disable-quota-anonymous: "true"
      client.quota.callback.static.produce: "699050"
      client.quota.callback.static.storage.check-interval: "30"
      client.quota.callback.static.storage.hard: "30601641984"
      client.quota.callback.static.storage.soft: "28991029248"
      default.replication.factor: 3
      inter.broker.protocol.version: 2.7.0
      leader.imbalance.per.broker.percentage: 0
      log.message.format.version: 2.7.0
      max.connections: "33"
      max.connections.creation.rate: "16"
      min.insync.replicas: 2
      offsets.topic.replication.factor: 3
      quota.window.num: "30"
      quota.window.size.seconds: "2"
      ssl.enabled.protocols: TLSv1.3
      ssl.protocol: TLSv1.3
      strimzi.authorization.global-authorizer.acl.1: permission=allow;topic=*;operations=all
      strimzi.authorization.global-authorizer.acl.2: permission=allow;group=*;operations=all
      strimzi.authorization.global-authorizer.acl.3: permission=allow;transactional_id=*;operations=all
      strimzi.authorization.global-authorizer.allowed-listeners: PLAIN-9092,SRE-9096
      transaction.state.log.min.isr: 2
      transaction.state.log.replication.factor: 3
    jvmOptions:
      -XX:
        ExitOnOutOfMemoryError: "true"
      -Xms: 512m
      -Xmx: 512m
    listeners:
    - name: plain
      port: 9092
      tls: false
      type: internal
    - name: tls
      port: 9093
      tls: true
      type: internal
    - authentication:
        accessTokenIsJwt: true
        checkAccessTokenType: true
        checkIssuer: true
        clientId: kafka-1roj3ouqwhoz4hhf4w5sb1vcmek
        clientSecret:
          key: ssoClientSecret
          secretName: ${NAME}-sso-secret
        customClaimCheck: '@.rh-org-id == ''13639843'' && (( @.rh-user-id && @.rh-user-id
          ==''53687049'') || !@.rh-user-id)'
        enableOauthBearer: true
        enablePlain: true
        jwksEndpointUri: https://identity.api.stage.openshift.com/auth/realms/rhoas/protocol/openid-connect/certs
        tlsTrustedCertificates:
        - certificate: keycloak.crt
          secretName: ${NAME}-sso-cert
        tokenEndpointUri: https://identity.api.stage.openshift.com/auth/realms/rhoas/protocol/openid-connect/token
        type: oauth
        userNameClaim: preferred_username
        validIssuerUri: https://identity.api.stage.openshift.com/auth/realms/rhoas
      configuration:
        bootstrap:
          host: teenage-mu--roj-ouqwhoz-hhf-w-sb-vcmek.kafka.devshift.org
        brokerCertChainAndKey:
          certificate: tls.crt
          key: tls.key
          secretName: ${NAME}-tls-secret
        brokers:
        - broker: 0
          host: broker-0-teenage-mu--roj-ouqwhoz-hhf-w-sb-vcmek.kafka.devshift.org
        - broker: 1
          host: broker-1-teenage-mu--roj-ouqwhoz-hhf-w-sb-vcmek.kafka.devshift.org
        - broker: 2
          host: broker-2-teenage-mu--roj-ouqwhoz-hhf-w-sb-vcmek.kafka.devshift.org
      name: external
      port: 9094
      tls: true
      type: route
    - authentication:
        accessTokenIsJwt: true
        checkAccessTokenType: true
        checkIssuer: true
        clientId: kafka-1roj3ouqwhoz4hhf4w5sb1vcmek
        clientSecret:
          key: ssoClientSecret
          secretName: ${NAME}-sso-secret
        customClaimCheck: '@.rh-org-id == ''13639843'' && (( @.rh-user-id && @.rh-user-id
          ==''53687049'') || !@.rh-user-id)'
        enableOauthBearer: true
        jwksEndpointUri: https://identity.api.stage.openshift.com/auth/realms/rhoas/protocol/openid-connect/certs
        tlsTrustedCertificates:
        - certificate: keycloak.crt
          secretName: ${NAME}-sso-cert
        type: oauth
        userNameClaim: preferred_username
        validIssuerUri: https://identity.api.stage.openshift.com/auth/realms/rhoas
      name: oauth
      port: 9095
      tls: false
      type: internal
    - name: sre
      port: 9096
      tls: false
      type: internal
#    XmetricsConfig:
#      type: jmxPrometheusExporter
#      valueFrom:
#        configMapKeyRef:
#          key: jmx-exporter-config
#          name: ${NAME}-kafka-metrics
    rack:
      topologyKey: topology.kubernetes.io/zone
    replicas: 3
    resources:
      limits:
        cpu: ${KAFKA_CPU}
        memory: ${KAFKA_MEM}
      requests:
        cpu: ${KAFKA_CPU}
        memory: ${KAFKA_MEM}
    storage:
      type: jbod
      volumes:
      - class: $STORAGE_CLASS
        deleteClaim: true
        id: 0
        size: "32212254720"
        type: persistent-claim
    template:
      pod:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - topologyKey: kubernetes.io/hostname
    version: 2.7.0
  kafkaExporter:
    resources:
      limits:
        cpu: 1000m
        memory: 256Mi
      requests:
        cpu: 500m
        memory: 128Mi
  zookeeper:
    jvmOptions:
      -XX:
        ExitOnOutOfMemoryError: "true"
      -Xms: 512m
      -Xmx: 512m
#    XmetricsConfig:
#      type: jmxPrometheusExporter
#      valueFrom:
#        configMapKeyRef:
#          key: jmx-exporter-config
#          name: ${NAME}-zookeeper-metrics
    replicas: 3
    resources:
      limits:
        cpu: ${ZOOKEEPER_CPU}
        memory: ${ZOOKEEPER_MEM}
      requests:
        cpu: ${ZOOKEEPER_CPU}
        memory: ${ZOOKEEPER_MEM}
    storage:
      class: $STORAGE_CLASS
      deleteClaim: true
      size: 10Gi
      type: persistent-claim
    template:
      pod:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - topologyKey: kubernetes.io/hostname
            - topologyKey: topology.kubernetes.io/zone
EOF

done
