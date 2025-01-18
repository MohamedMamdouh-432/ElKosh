import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "elkoshecommerce",
          "private_key_id": "44b88dd6aff877fdc1196fd2f48ba9e564e180ad",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC71EVWapRt+IP5\nxDSS6nFGUXvbpYAaB+s0LHZk7gLxtG/eqypcxGkl6SjZZ3xi6R415jyfAVLMq6TQ\nvAPeoJ2cpPt4zdEsaUg9SvDCK//Dg2XoaJJfsgfCtCPXsKLdo8HgiaoOGU77lWTH\nG6c8CKBF7kZMjbk2ipCySNj7qEmV3SXjkMe0VnMIZjP+awOhvSpRpEDm8Rps7y0Z\nN+0zYAF4p6fjZXB8ekX+PNC/kR+awzLmwAQ+FoB8MxmFzgedEtqeQTqsi2uPkA1e\nqg47Bmx681sZY1Fom82cDD+czjrZi1coeA+Myn7GIdroqzV2kOKbwqLwStVCcYjn\nP5ck5eTZAgMBAAECggEAMUA1WDYFKprV/EmS4Y0g26flGtCYOPsnlNwtxURVuEww\nY0othvqneZ3cLLmCd6sZ1VdEQQtHS0ycoHEUcK1b9qWaHPCW7xbCLvQ2EiwYWgtb\nzueQrhAQEeFLXrS91/EnFrnyQdUoDTb8oGrjXI4EfKHAhDVLQf5ud5k7cC2N8gIC\nfDQ9naCG1FBj6FPygoANtPAZ6EogN7CQhNcvSj1lmzYCrGKUdB6LVkOW6qGO2o7L\nFFYlyxxF83cbtfx1LpDdD9FuRxIzSa/j2hY+jgpXGmq7RCZBx4Vu25v1jNsYO+ab\neo6Nd+iiR9xaWs3mf/m0fgILH1x/IuAh9heoFdl1WwKBgQDcQThndkd1cNz4L44X\n/bOI+9OsmZxhkFfCFinpzaI3mzndB6ZebE61QQPXKOKpcuS5TAkUbRQ0P5KoLTQd\nVmTjRNuwZvNvzZJNxpLIYrcoFqMcIVdOq2agh/XbYJXoAjcA9g//a0W9H7kkPAcg\nh/AOQGmnjwmLDKmhBf9Y3WwwpwKBgQDaT+La5ICTFGh6nHXsjN8iDdthzWid/W97\nrQF7mobQGvHlAwqQcpSsP+TbBDDXcoBlwml/3jT0YoJgsI8VGPtcx/pviAzYn+Gs\nle/UnW4jrIPTGbi4yReskU7i989m02JRyO8qM5ZY3vyFFFYPlf6fV5fNICzSPOIA\nJNwhvl5ufwKBgGTnXDfJ8CLVeeYZozdKex2egPLpzMLFpe68yKbcFhzzeCbSgl1v\nsP9IscG4cV6/zBk3xFEfR8pH9aAmVWG7WqzjtuGxyITH4ObQuh4jW1V6SW9xttXL\noFCa+P9v2D1aBmjiUaHqOyDRj7gR6BH3NPrSd5TT6sNRIcUrQjgr+IyxAoGABXg+\n7NEQz56RR5En+zdEV+wU9QxadKrm4ihhgyFKA2jJar16xEe6pd4r87jVKHC7+tC2\nJ/f/R6g4MAf8bcDke1yfT7AO8lZ/Jv3StncDTW2DGATq9eZD65TwbwtabO8a5YWt\nSFdmiu97UDJEPbu6V2+wY/lMZjAUUYCa61WDtC0CgYEAwJ4gqgus1soZYArW+OO+\nEV4BjU5qKPnKwuot3fRJ0iMxYtjbHOzJVj0L65ClGJsPzTwXfbIgIAV3ikBEkqNm\nHgDsiv/T3Vjme9eLg5yS+YvvuOIuTdfLmp67I5U58pT1BmkI7GISrb/6xFc9WVE0\n+RJ/DR5txoCwpyoS0vJ8jUw=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-mg1pb@elkoshecommerce.iam.gserviceaccount.com",
          "client_id": "117197805776898954860",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mg1pb%40elkoshecommerce.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        },
      ),
      scopes,
    );
    final accServerKey = client.credentials.accessToken.data;
    return accServerKey;
  }
}
