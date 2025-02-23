// class ArtikelPertanianCard extends StatelessWidget {
//   final String judulArtikel;
//   final String penulis;
//   final String tanggalPublikasi;
//   final String gambarUrl;

//   const ArtikelPertanianCard({
//     super.key,
//     required this.judulArtikel,
//     required this.penulis,
//     required this.tanggalPublikasi,
//     required this.gambarUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.network(
//               gambarUrl,
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 120,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.error, color: Colors.red),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(judulArtikel,
//                     style: TStyle.head5,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 4),
//                 Text('Oleh: $penulis', style: TStyle.bodyText3),
//                 const SizedBox(height: 2.0),
//                 Text(tanggalPublikasi, style: TStyle.bodyText3),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 30,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                     ),
//                     onPressed: () {
//                       Get.toNamed(ArtikelRoutes.artikel);
//                     },
//                     child: const Text('Baca Artikel'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
