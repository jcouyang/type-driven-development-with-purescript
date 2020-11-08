import React from "react";
import { send, channel } from "./output/Signal.Channel";
import { unsafePerformEffect } from "./output/Effect.Unsafe";
import {subscribeChannel, doNothing} from "./output/WithState"

export default function withState(WrappedComponent, initState, initAction) {
  const context = React.createContext({
    state: initState,
    dispatch: (action) => {}
  });

  class Component extends React.Component {
    constructor(props) {
      super(props);
      this.state = initState;
      this.channel = unsafePerformEffect(channel(doNothing));
    }

    componentDidMount() {
      unsafePerformEffect(subscribeChannel(this.channel)(this.state)((sts)=>()=>this.setState(sts)));
      unsafePerformEffect(send(this.channel)(initAction(this.props)))
    }
    render() {
      return (
        <context.Provider
          value={{
            state: this.state,
            dispatch: action => {
              unsafePerformEffect(send(this.channel)(action));
            }
          }}
        >
          <WrappedComponent {...this.props} />
        </context.Provider>
      );
    }
  }

  return { context, Component };
}
