// import 'package:bunna_app/api/bank/single_transaction_detail.dart';

// import 'package:bunna_app/widgets/transaction/bloc_transac/single_detail_trasac/single_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../cubit/app_cubits.dart';

class AppBlocProviders {

  AppBlocProviders();

  static get allBlocProviders => [
        BlocProvider(
          lazy: false,
          create: (context) => AppCubits(),
        ),
        // BlocProvider(
        //   create: (context) => ShowMoreBloc(),
        // ),

      ];
}
