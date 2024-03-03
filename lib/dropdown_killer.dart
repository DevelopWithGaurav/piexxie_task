import 'package:flutter/material.dart';

class DropDownKiller<T> extends StatefulWidget {
  const DropDownKiller({Key? key, required this.data, required this.onSelected, this.title}) : super(key: key);

  final List<T> data;
  final Function(T result) onSelected;
  final String? title;

  @override
  State<DropDownKiller<T>> createState() => _DropDownKillerState<T>();
}

class _DropDownKillerState<T> extends State<DropDownKiller<T>> {
  List<T> searchedList = [];

  TextEditingController textEditingController = TextEditingController();

  onSearched(String key) {
    searchedList.clear();
    searchedList.addAll(widget.data.where((element) => element.toString().toLowerCase().contains(key.toLowerCase())).toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool searched = textEditingController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextFormField(
                controller: textEditingController,
                onChanged: onSearched,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  label: const Text('Search'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searched ? searchedList.length : widget.data.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.circle,
                      size: 12,
                    ),
                    title: Text(
                      searched ? searchedList[index].toString() : widget.data[index].toString(),
                    ),
                    onTap: () {
                      searched ? widget.onSelected(searchedList[index]) : widget.onSelected(widget.data[index]);
                      // Navigator.pop(context);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
