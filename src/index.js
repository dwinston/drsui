import  { Elm } from "./Main.elm"

let app = Elm.Main.init();
app.ports.saveJwt.subscribe((jwt) => {
    localStorage.setItem("jwt", jwt);
})
