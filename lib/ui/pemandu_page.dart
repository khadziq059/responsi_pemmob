import 'package:flutter/material.dart';
import 'package:pariwisata/bloc/logout_bloc.dart';
import 'package:pariwisata/bloc/pemandu_bloc.dart';
import 'package:pariwisata/model/pemandu.dart';
import 'package:pariwisata/ui/login_page.dart';
import 'package:pariwisata/ui/pemandu_detail.dart';
import 'package:pariwisata/ui/pemandu_form.dart';

class PemanduPage extends StatefulWidget {
  const PemanduPage({Key? key}) : super(key: key);

  @override
  _PemanduPageState createState() => _PemanduPageState();
}

class _PemanduPageState extends State<PemanduPage> {
  // Definisi warna kustom
  final primaryGreen = const Color(0xFF2E7D32); // Hijau gelap
  final secondaryYellow = const Color(0xFFFFEB3B); // Kuning cerah
  final lightYellow = const Color(0xFFFFFDE7); // Kuning sangat muda
  final mediumGreen = const Color(0xFF4CAF50); // Hijau medium

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'List Pemandu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryGreen,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryYellow,
                foregroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Tambah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PemanduForm()));
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryGreen, mediumGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryYellow,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.person, size: 40, color: primaryGreen),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Menu Pemandu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: primaryGreen),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await LogoutBloc.logout().then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightYellow, Colors.white],
          ),
        ),
        child: FutureBuilder<List>(
          future: PemanduBloc.getPemandus(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListPemandu(
                    list: snapshot.data,
                    primaryGreen: primaryGreen,
                    secondaryYellow: secondaryYellow,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class ItemPemandu extends StatelessWidget {
  final Pemandu pemandu;
  final Color primaryGreen;
  final Color secondaryYellow;

  const ItemPemandu({
    Key? key,
    required this.pemandu,
    required this.primaryGreen,
    required this.secondaryYellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PemanduDetail(pemandu: pemandu),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, const Color(0xFFF9FBE7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: secondaryYellow.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: secondaryYellow.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryGreen,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pemandu.guide!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: secondaryYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pemandu.languages!,
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 18,
                            color: secondaryYellow,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rating: ${pemandu.rating}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListPemandu extends StatelessWidget {
  final List? list;
  final Color primaryGreen;
  final Color secondaryYellow;

  const ListPemandu({
    Key? key,
    this.list,
    required this.primaryGreen,
    required this.secondaryYellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPemandu(
          pemandu: list![i],
          primaryGreen: primaryGreen,
          secondaryYellow: secondaryYellow,
        );
      },
    );
  }
}
