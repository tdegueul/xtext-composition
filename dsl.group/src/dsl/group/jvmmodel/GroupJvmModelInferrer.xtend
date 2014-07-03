package dsl.group.jvmmodel

import com.google.inject.Inject
import dsl.entity.entity.Entity
import dsl.group.group.Group
import java.util.List
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

class GroupJvmModelInferrer extends AbstractModelInferrer
{
	@Inject extension JvmTypesBuilder

	def dispatch void infer(Group g, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		acceptor.accept(g.toClass(g.name))
		.initializeLater[
			g.entities.forEach[e |
				members += g.toField(e.attrName + "sList", g.newTypeRef(List, newTypeRef(e.name)))
			]

			members += g.toMethod("toString", g.newTypeRef(String))[
				body = '''
					return "I'm a group with «g.entities.size» different entities!" ;
				'''
			]
		]
	}

	private def getAttrName(Entity e) '''«e.name.toLowerCase»sList'''
}
