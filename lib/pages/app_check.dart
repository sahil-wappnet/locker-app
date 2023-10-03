// import 'package:encrypt/encrypt.dart';
// import 'package:flutter/material.dart';
// import 'package:pointycastle/asymmetric/api.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String publicKeyPEM = '''
// -----BEGIN PUBLIC KEY-----
// MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm/mlxo/HT5b5GcZ9WhTF
// 0QuFys8cyLDPO16Q6RqYmH47wZNxNsnka5CFdj9i1TSEnha5rKyRbwI03JruxohK
// o232pZWuD9cUbc7bsueCGZpnTXOmPlIRaenFPZlWEVEyH0yaH4Kb/Iq9ApoihsLw7
// PNJmYV3XDsdW/YE5FGGKcR8kJuCF9/Teu0QX+d8xFwIAxZHBTWpku5x78Qk+zWBJb
// /yfRLoRM5+KZO4En9Jg6hWrLv3LT4VuG25CzbInumicCUvyLc0wcd0d3FCOx//LT
// B+wBIVUpd7e6fErIzjG2NAoD5QOoj0OeVUPxFS6X3kqCjOD6qVn8iRDjUv5rzLyQ
// IDAQAB
// -----END PUBLIC KEY-----
// ''';

//   String privateKeyPEM = '''
//     -----BEGIN RSA PRIVATE KEY-----
//     MIIEowIBAAKCAQEAm/mlxo/HT5b5GcZ9WhTF0QuFys8cyLDPO16Q6RqYmH47wZNx
//     Nsnka5CFdj9i1TSEnha5rKyRbwI03JruxohKo232pZWuD9cUbc7bsueCGZpnTXOm
//     PlIRaenFPZlWEVEyH0yaH4Kb/Iq9ApoihsLw7PNJmYV3XDsdW/YE5FGGKcR8kJuC
//     F9/Teu0QX+d8xFwIAxZHBTWpku5x78Qk+zWBJb/yfRLoRM5+KZO4En9Jg6hWrLv3
//     LT4VuG25CzbInumicCUvyLc0wcd0d3FCOx//LTB+wBIVUpd7e6fErIzjG2NAoD5Q
//     Ooj0OeVUPxFS6X3kqCjOD6qVn8iRDjUv5rzLyQIDAQABAoIBACfGS8YraW4DUJTA
//     G/O32IY/GQytien4tl/6KMUNZJY04bq6/0kbDDgN2TCCEMBM1jrRgq7Zi7SYtvcf
//     dGHpmfmG3iL0a8JM3I/pTbmhtU9XGMliEQwOjLlk8htOU/3ysKifflK568IrP8bw
//     S79RbgPISX14KnjkGwKCZ/vHJM5+QKBgQDwv/ISFhoq9xKRxTgD8HvG+mu/PCDzu
//     ENcpuJS9Db8160ZlC+cA5BTbNSfi7i7+S1b9UBBvyTdTKkPii+/dTUYBzvoQygA7
//     yUUGiPYZc4u88tzS8i0HS0gYKz8lH66oOvKWOBzwztSE+ULoM1yjBQi3B7neF1VC
//     1j/3DMjtWs58QKBgEJnB3IcX7NOzWTJJOFJ+K6HAObtgeWfV7n8BbyUk21Bc+ku7
//     6u5ADlExWf6fMTOgolH5YjLoDUtD6iaVs5wFKNEye5JaO3FLCUGNsDGe8+tdLAgj
//     J04XS/Wm2uC5S590Phy7Y5m3nYXhi42Vf9djvG5mxdhWmbhS0ZxN/Bbk9M5AoGA
//     KINrdyJTmSSNO73CMhzAhrO9ztqfwGkR7zAeAUFFqNIQx+5P9UgIr+TYBwgd75ls
//     OshWtKHXgvmPvgN8fgTKvSlbcUuqWJWVUkL+L6ERUgcv+6wsbZxBYDdA5wmsNSG
//     oJGhFMqEV2cLrGd1LOjB2sD1GKUUsyVOqGYwOHRXFnlM=
//     -----END RSA PRIVATE KEY-----
//   ''';

//   RSAPublicKey? publicKey;
//   RSAPrivateKey? privateKey;

//   String plaintext = '';
//   String encryptedText = '';
//   String decryptedText = '';

//   @override
//   void initState() {
//     super.initState();
//     parseKeys();
//   }

//   void parseKeys() {
//     publicKey = RSAKeyParser().parse(publicKeyPEM) as RSAPublicKey?;
//     privateKey = RSAKeyParser().parse(privateKeyPEM) as RSAPrivateKey?;
//   }

//   String encrypt(String plaintext, RSAPublicKey publicKey) {
//     final encrypter = Encrypter(RSA(publicKey: publicKey));
//     final encrypted = encrypter.encrypt(plaintext);
//     return encrypted.base64;
//   }

//   String decrypt(String encryptedText, RSAPrivateKey privateKey) {
//     final encrypter = Encrypter(RSA(privateKey: privateKey));
//     final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText));
//     return decrypted;
//   }

//   void _handleEncrypt() {
//     if (publicKey != null) {
//       final encrypted = encrypt(plaintext, publicKey!);
//       setState(() {
//         encryptedText = encrypted;
//       });
//     }
//   }

//   void _handleDecrypt() {
//     if (privateKey != null) {
//       final decrypted = decrypt(encryptedText, privateKey!);
//       setState(() {
//         decryptedText = decrypted;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('RSA Encryption & Decryption'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   plaintext = value;
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Enter Text to Encrypt'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _handleEncrypt,
//               child: Text('Encrypt'),
//             ),
//             SizedBox(height: 16.0),
//             Text('Encrypted Text: $encryptedText'),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _handleDecrypt,
//               child: Text('Decrypt'),
//             ),
//             SizedBox(height: 16.0),
//             Text('Decrypted Text: $decryptedText'),
//           ],
//         ),
//       ),
//     );
//   }
// }
