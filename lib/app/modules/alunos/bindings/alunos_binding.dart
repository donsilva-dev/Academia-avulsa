import 'package:cademia_avulsa/app/data/repositories/log_repository.dart';
import 'package:cademia_avulsa/app/modules/alunos/controllers/alunos_controller.dart';
import 'package:get/get.dart';

import '../../../data/repositories/aluno_repository.dart';

class AlunosBinding extends Bindings {
   @override
  void dependencies() {
    Get.lazyPut<AlunoRepository>(() => AlunoRepository());
    Get.lazyPut<LogRepository>(() => LogRepository());        // ⭐ novo

    Get.lazyPut<AlunosController>(
      () => AlunosController(
        Get.find<AlunoRepository>(),
        Get.find<LogRepository>(),                             // ⭐ novo
      ),
    );
  }
}
