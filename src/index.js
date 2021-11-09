import  { Elm } from "./Main.elm"

let app = Elm.Main.init({
    flags: {jwt: localStorage.getItem("jwt")}
});
app.ports.saveJwt.subscribe((jwt) => {
    localStorage.setItem("jwt", jwt);
})
