import 'package:drone_tech/src/feature/drone/data/cloud_firestore_service.dart';
import 'package:drone_tech/src/feature/drone/presentation/drone_page/drone_page_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//ConsumerStatefulWidget from Riverpod. An equivalent of StatefulWidged.
class DronePage extends ConsumerStatefulWidget {
  const DronePage({Key? key}) : super(key: key);

  @override
  ConsumerState<DronePage> createState() => _DronePageState();
}

class _DronePageState extends ConsumerState<DronePage> {
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //An instance of our firestoreDBProvider to be used in StreamBuilder.
    final streamProvider = ref.watch(firestoreDBProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 80, 79, 80),
      appBar: AppBar(
        title: const Center(
          child: Text('Available Drone'),
        ),
      ),
      body: StreamBuilder(
        stream: streamProvider.collectionStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final documentSnapshot = streamSnapshot.data!.docs[index];
                return Scrollbar(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ID: ${documentSnapshot['idtag']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color:
                                        const Color.fromARGB(255, 80, 79, 80),
                                    onPressed: () async {
                                      await ref
                                          .read(dronePageRepositoryProvider)
                                          .deleteDrone(documentSnapshot.id);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date: ${documentSnapshot['date'].toDate().toString().split(' ')[0]}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Manufacturer: ${documentSnapshot['manufacturer']}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Weight capacity: ${documentSnapshot['weightcapacity'].toString()} Kg',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Drone Status:',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        documentSnapshot['served'] == false
                                            ? const Text(
                                                'Served',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : const Text(
                                                'Not Serviced',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await ref
                                                .read(droneStatusProvider
                                                    .notifier)
                                                .changeStatus(
                                                    documentSnapshot.id,
                                                    documentSnapshot['served']
                                                        as bool);
                                          },
                                          child: documentSnapshot['served'] ==
                                                  false
                                              ? const Text('Delivered')
                                              : const Text('Order'),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Register your own Drone!',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  content: SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            '[ID will be generated automatically]',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(),
                          TextField(
                            maxLength: 15,
                            controller: manufacturerController,
                            decoration: const InputDecoration(
                                labelText: 'Manufacturer'),
                          ),
                          TextField(
                            maxLength: 5,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: weightController,
                            decoration: const InputDecoration(
                                labelText: 'Weight Capacity (in kg)'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final manufacturer = manufacturerController.text;
                              final double? weightCapacity =
                                  double.tryParse(weightController.text);
                              if (manufacturer != '' &&
                                  weightCapacity != null) {
                                await ref
                                    .read(dronePageRepositoryProvider)
                                    .createDrone(manufacturer, weightCapacity);
                                manufacturerController.text = '';
                                weightController.text = '';
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Register Now'),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(240, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
