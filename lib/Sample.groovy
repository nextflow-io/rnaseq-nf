
import java.nio.file.Path
import nextflow.io.ValueObject
import nextflow.util.KryoHelper

@ValueObject
class Sample {
  String id
  List<Path> reads

  static {
    KryoHelper.register(Sample)
  }
}
