module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation exposing (Key)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Http
import Jwt exposing (Jwt)
import Route exposing (Route)
import Url exposing (Url)


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key
      , route = Route.parse url
      , jwt = Nothing
      , draftClientId = ""
      , draftClientSecret = ""
      }
    , Cmd.none
    )


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
    | UserWantsToLogin
    | UserTypedInClientIdField String
    | UserTypedInClientSecretField String


type alias Model =
    { key : Key
    , route : Route
    , jwt : Maybe Jwt
    , draftClientId : String
    , draftClientSecret : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequest (Browser.Internal url) ->
            ( model, Navigation.pushUrl model.key (Url.toString url) )

        UrlRequest (Browser.External str) ->
            ( model, Navigation.load str )

        UrlChange url ->
            ( { model | route = Route.parse url }, Cmd.none )

        UserWantsToLogin ->
            -- grant_type = "client_credentials", client_id = '', client_secret = ''
            -- ( model, Http.post { url = "https://api.dev.microbiomedata.org/token" } )
            Debug.todo "user wants to log in"

        UserTypedInClientIdField newDraftClientId ->
            ( { model | draftClientId = newDraftClientId }, Cmd.none )

        UserTypedInClientSecretField newDraftClientSecret ->
            ( { model | draftClientSecret = newDraftClientSecret }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "hello"
    , body =
        [ Html.header []
            [ Html.div [] [ Html.text "Header" ]
            , case model.jwt of
                Nothing ->
                    Html.nav []
                        [ Html.a [ Attrs.href "/login" ] [ Html.text "Sign In" ] ]

                Just _ ->
                    Html.nav []
                        [ Html.text "TODO" ]
            ]
        , Html.main_ [] [ viewPageContent model ]
        , Html.text <| Debug.toString model
        , Html.footer [] [ Html.text "Footer" ]
        ]
    }


viewPageContent : Model -> Html Msg
viewPageContent model =
    case model.route of
        Route.Login ->
            Html.form [ Events.onSubmit UserWantsToLogin ]
                [ Html.label []
                    [ Html.text "client ID"
                    , Html.input
                        [ Attrs.type_ "text"
                        , Attrs.value model.draftClientId
                        , Events.onInput UserTypedInClientIdField
                        ]
                        []
                    ]
                , Html.label []
                    [ Html.text "client secret"
                    , Html.input
                        [ Attrs.type_ "password"
                        , Attrs.value model.draftClientSecret
                        , Events.onInput UserTypedInClientSecretField
                        ]
                        []
                    ]
                , Html.button [ Attrs.type_ "submit" ] [ Html.text "Log in" ]
                ]

        Route.NotFound ->
            Html.text "NotFound"


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequest
        , onUrlChange = UrlChange
        }
