package fsm;

import fsm.exceptions.NotInTransitionException;

public class Transitioner {
	
	public void transition(FSM fsm) throws NotInTransitionException {
		if (fsm.transition == null) {
			throw new NotInTransitionException();
		}
		fsm.transition.run();
		fsm.transition = null;
	}
	
}
