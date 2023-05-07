import 'package:flutter/material.dart';

class ConvertouchItemsCollectionView extends StatefulWidget {
  const ConvertouchItemsCollectionView({super.key});

  @override
  State createState() => _ConvertouchItemCollectionViewState();
}

class _ConvertouchItemCollectionViewState
    extends State<ConvertouchItemsCollectionView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 1,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0x00FFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF366C9F),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 50,
                    height: MediaQuery.of(context).size.height * 1,
                    decoration: const BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.all_inbox_rounded,
                        color: Color(0xFF366C9F),
                        size: 25,
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                    color: Color(0xFF366C9F),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0x00FFFFFF),
                      ),
                      child: const Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Text(
                            'Length',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF366C9F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
