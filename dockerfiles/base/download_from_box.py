import boxsdk
from boxsdk import JWTAuth, Client
from os.path import join
import sys


def find(directory, filename):
    if isinstance(directory, boxsdk.object.folder.Folder):
        for entry in directory.get().item_collection['entries']:
            fobj = find(entry, filename)
            if not (fobj is None):
                return fobj
    else:
        if directory.name == filename:
            return directory

    return None


def download_from_box(shared_link, filename, save_path):
    print("Searching for %s in %s" % (filename, shared_link))
    sdk = JWTAuth.from_settings_dictionary({
        "boxAppSettings": {
            "clientID": "ind0ahpt188454gosng4g7ya6l5lmsq1",
            "clientSecret": "Dk74vXtPYzK4sYwMQh3n90XGwMzdiaH3",
            "appAuth": {
                "publicKeyID": "kt1mdzwh",
                "privateKey": "-----BEGIN ENCRYPTED PRIVATE KEY-----\n"
                              "MIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIAa1gdYCiysUCAggA\n"
                              "MBQGCCqGSIb3DQMHBAjbV5j2FCE5RgSCBMjpKnSsHXzW9S5ivkAgf/3Neg1AJNGu\n"
                              "RFXbcw/iZZMRl+jb5Q6O+eOH9Ofz7okEg3MIHeN0vb5TcDI1VwtBHsdMs9gChKei\n"
                              "K+XrY6g2VWInYprk4egaZHZ89lQl744OEY0o6FRyggQkFX2nfkVevV/UNC4LYM/n\n"
                              "P/0q2AWzSx3Yb9i/aB2xQcQAquGQ3qtZomuJHzghFLioiVDKIyy+Ol2hUdi9VYM9\n"
                              "na8iI5gl9NujcUvVVuD7oH56BzYEC1Rtz+dDIfHEOjM1PollKRSdzVEf93zD90vT\n"
                              "PMVV63gM7dL8qalgJOCNlThld5AHZ5qCXuTdLv5Ly/4/uIztjbj810Uvl2PziXyb\n"
                              "oaP4FEhIu6YNSEPG7hWm4XMKdm2OFZzzPlaBGWpfN5MXhTc1cIvRjqKndAFGThg5\n"
                              "FO+B893ViwyGYBvMPYXvR/8VJaQXkPSbb401x+rt8Xb7CkYFKskRCJYknc9fhPgL\n"
                              "VljSzk2eZMyYYkF1FNjWhe/EmUpnxzW+frqbIOyCM6LNDYr4PdoHG5n2DdwxJQ9L\n"
                              "ClpXaKpFuRAT4nMabkzZk7oyfxeUL1raWk41kBlx2X4XWoWAJcZbqI40qkiWx4Q4\n"
                              "oHhjINH9Vn3r0YbkUh2603QRvNcJ8HQnAaEM+zRQz2M+8NpXqF/4j+sYzEU4pniW\n"
                              "QQRQTDunyBkPNJzL//g1yZONubbHqX28FN6qNdsFxa/HqHHh9hy973KbipaIqkY9\n"
                              "RgAkpnmT1DKLOuh7cxoTxfrJWk3fqxszxakv9vcFBDK9ADA/JSLlnhAkKYI9Wokx\n"
                              "DmdG7f0QnJgHcIXATlLoQeCAh4xG/nIM25EnUty84ojm74odSzv7y0DXUVj4zak2\n"
                              "ZBkd3h52r6ybqSZEKtP3qQzjt6NB/XtjSGM8xl56et5rDqgtrs/+To6GT6qaOLoE\n"
                              "SokrdB+tv+BBrRNXZAoIR3rb6oiOPEoysTEF4HumkWG4RPjigr0jqf3CX97CKpHm\n"
                              "ZQdqzsqK8SM1M1OBXUZdE9cqlEa052o86bp3P0RUUYb9qqxEPScb9qDJGGdhKSLo\n"
                              "VoA2nmADTmisoOWIaytJfSQDyZcGEX/0IJDSWKFOP1kvz8FaopPekY3URxScy5Yb\n"
                              "ge5lAJRX5ZQM7RSV5FoMSGX92E2BOeYLLmWd5WKyw3HIoYC3ScJYZOqJCZl0TeN5\n"
                              "/OGaMFttF3foHb2aiLq7nhPyVajw8B+3DVayCQQLIh0+zAeieke8UaPHnNIcCO9W\n"
                              "ndwtOVXS4KslfxA6EcXK4W5cseJRbGx/8fcUZOwZ+xLN5wcr3jwmHnIivCRU1Fl4\n"
                              "QnBww6jGeiwDntrt3ZeSpB2GYA6NbiBDkzbveLomLX4+Ok0PreuiR5PhhnPK0mLu\n"
                              "GE2R2uEPwfIsHky/UEi8LI3zh3KjrCcHG2Kx89iBXYA+XUmBh+1Oh/t8MR7jYdBN\n"
                              "GO2HG2LIV29koChcNsY/ml2ex/nFO8iMnm8kQCy1bD1If6wApwBeJrFdS9wDkKca\n"
                              "f6EtaG1RLiqhA1iCITLxTE1QxCniirRCyq6UX5EOXQzcQt0bPRlXtcZba9dDn7H0\n"
                              "6WHJ+9LAz8C5lDAY89DRJ1yOxs/AEa/h+yDlhCxg23knNY0rlY4Y0AI4+VoTe0Op\n"
                              "RcE=\n"
                              "-----END ENCRYPTED PRIVATE KEY-----\n",
                "passphrase": "b6c4dd684581a9ce00dc97abab73357c"
            }
        },
        "enterpriseID": "197930301"
    })
    client = Client(sdk)
    root = client.get_shared_item(shared_link)
    fobj = find(root, filename)
    if fobj is None:
        print("File not found: %s" % filename)
    else:
        print("Start to download: %s" % filename)
        output_file = open(join(save_path, filename), 'wb')
        fobj.download_to(output_file)
        print("Download done")


if __name__ == "__main__":
    assert len(sys.argv) == 4
    download_from_box(sys.argv[1], sys.argv[2], sys.argv[3])

