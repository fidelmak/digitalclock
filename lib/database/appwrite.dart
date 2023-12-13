import 'package:appwrite/appwrite.dart';

class AppwriteClient {
  late Client client;

  AppwriteClient() {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6578cb370dcd79d03b20')
        .setSelfSigned(status: true);
  }
}
