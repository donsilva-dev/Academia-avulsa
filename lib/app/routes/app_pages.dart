
import 'package:cademia_avulsa/app/modules/alunos/views/aluno_form_view.dart';
import 'package:cademia_avulsa/app/modules/alunos/views/alunos_view.dart';
import 'package:get/get.dart';
import '../modules/alunos/bindings/alunos_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.alunos,
      page: () => const AlunosView(),
      binding: AlunosBinding(),
    ),
    GetPage(name: AppRoutes.alunoForm, page: () => const AlunoFormView()),
  ];
}
