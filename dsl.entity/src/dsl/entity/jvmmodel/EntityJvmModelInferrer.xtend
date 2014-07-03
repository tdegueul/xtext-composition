package dsl.entity.jvmmodel

import com.google.inject.Inject
import dsl.entity.entity.Entity
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

class EntityJvmModelInferrer extends AbstractModelInferrer
{
	@Inject extension JvmTypesBuilder

	def dispatch void infer(Entity e, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		acceptor.accept(e.toClass(e.name))
		.initializeLater[
			e.attrs.forEach[a |
				members += e.toField(a.name, a.type)
			]

			members += e.toMethod("toString", e.newTypeRef(String))[
				body = '''
					return "I'm a «e.name»!" ;
				'''
			]
		]
	}
}
