open Lwt
open Cohttp
open Cohttp_lwt_unix

let today = Unix.localtime (Unix.time ())
let day = today.Unix.tm_mday
let month = today.Unix.tm_mon + 1
let year = today.Unix.tm_year + 1900

type place_name = { default : string; fr : string option }
[@@deriving serialize, deserialize]

type team_name = { default : string; fr : string option }
[@@deriving serialize, deserialize]

type team_common_name = { default : string; fr : string option }
[@@deriving serialize, deserialize]

type team_abbrev = { default : string } [@@deriving serialize, deserialize]

type team_stats = {
  conferenceAbbrev : string;
  conferenceHomeSequence : int;
  conferenceL10Sequence : int;
  conferenceName : string;
  conferenceRoadSequence : int;
  conferenceSequence : int;
  date : string;
  divisionAbbrev : string;
  divisionHomeSequence : int;
  divisionL10Sequence : int;
  divisionName : string;
  divisionRoadSequence : int;
  divisionSequence : int;
  gameTypeId : int;
  gamesPlayed : int;
  goalDifferential : int;
  goalDifferentialPctg : float;
  goalAgainst : int;
  goalFor : int;
  goalsForPctg : float;
  homeGamesPlayed : int;
  homeGoalDifferential : int;
  homeGoalsAgainst : int;
  homeGoalsFor : int;
  homeLosses : int;
  homeOtLosses : int;
  homePoints : int;
  homeRegulationPlusOtWins : int;
  homeRegulationWins : int;
  homeTies : int;
  homeWins : int;
  l10GamesPlayed : int;
  l10GoalDifferential : int;
  l10GoalsAgainst : int;
  l10GoalsFor : int;
  l10Losses : int;
  l10OtLosses : int;
  l10Points : int;
  l10RegulationPlusOtWins : int;
  l10RegulationWins : int;
  l10Ties : int;
  l10Wins : int;
  leagueHomeSequence : int;
  leagueL10Sequence : int;
  leagueRoadSequence : int;
  leagueSequence : int;
  losses : int;
  otLosses : int;
  placeName : place_name;
  pointPctg : float;
  points : int;
  regulationPlusOtWinPctg : float;
  regulationPlusOtWins : int;
  regulationWinPctg : float;
  regulationWins : int;
  roadGamesPlayed : int;
  roadGoalDifferential : int;
  roadGoalsAgainst : int;
  roadGoalsFor : int;
  roadLosses : int;
  roadOtLosses : int;
  roadPoints : int;
  roadRegulationPlusOtWins : int;
  roadRegulationWins : int;
  roadTies : int;
  roadWins : int;
  seasonId : int;
  shootoutLosses : int;
  shootoutWins : int;
  streakCode : string;
  streakCount : int;
  teamName : team_name;
  teamCommonName : team_common_name;
  teamAbbrev : team_abbrev;
  teamLogo : string;
  ties : int;
  waiversSequence : int;
  wildcardSequence : int;
  winPctg : float;
  wins : int;
}
[@@deriving serialize, deserialize]

type standings_resp = {
  wild_card_indicator : bool option;
  standings : team_stats list;
}
[@@deriving serialize, deserialize]

let url =
  Printf.sprintf "https://api-web.nhle.com/v1/standings/%04d-%02d-%02d" year
    month day

let body =
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let print_team_names standings_resp =
  List.iter
    (fun team_stats -> Printf.printf "%s\n" team_stats.teamName.default)
    standings_resp

let () =
  let body = Lwt_main.run body in
  match Serde_json.of_string deserialize_standings_resp body with
  | Ok res ->
      print_endline "Deserialization successful.";
      print_team_names res.standings
  | Error err ->
      Printf.eprintf "Deserialization error: %s\n"
        (Serde.pp_err Format.str_formatter err;
         Format.flush_str_formatter ());
      Printf.eprintf "Response body: %s\n" body
