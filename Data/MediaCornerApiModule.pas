unit MediaCornerApiModule;

interface

uses
  System.SysUtils, System.JSON, REST.Client, REST.Types, Data.DB, FireDAC.Comp.Client, System.DateUtils;

procedure FetchPopularMoviesByPage(MovieList: TFDMemTable; PageNumber: Integer);

implementation

{
  Fetches a paginated list of popular movies from The Movie Database (TMDb) API
  and stores the results in a `TFDMemTable`.

  @param MovieList The in-memory dataset (`TFDMemTable`) where movie data will be stored.
  @param PageNumber The page number of the movie list to fetch.

  This procedure:
  - Initializes a REST client and constructs an API request to TMDb.
  - Retrieves a paginated list of popular movies.
  - Parses the JSON response and extracts relevant movie data.
  - Stores the movie details (ID, title, release date, and overview) in `TFDMemTable`.

  Notes:
  - Uses the API key stored in an environment variable (`API_KEY`).
  - Converts the `release_date` field from an ISO 8601 string to a `TDateTime`.
  - Ensures proper memory management by freeing the REST components in the `finally` block.
  - Throws exceptions if the API request fails or returns an invalid response.
}
procedure FetchPopularMoviesByPage(MovieList: TFDMemTable; PageNumber: Integer);
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONArr: TJSONArray;
  JSONObj: TJSONObject;
  i: Integer;
  Api: String;
  ApiKey: String;
  ReleaseDateStr: string;
  ReleaseDate: TDateTime;
begin
  // REST Client setup
  RESTClient := TRESTClient.Create('https://api.themoviedb.org/3/movie/popular');
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  try
    // Add API key and page parameter
    Api := GetEnvironmentVariable('API_KEY');
    ApiKey := 'Bearer ' + Api;

    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Method := rmGET;

    RESTRequest.Params.AddItem('Authorization', ApiKey, pkHTTPHEADER, [poDoNotEncode]);
    RESTRequest.AddParameter('page', IntToStr(PageNumber), pkGETorPOST);

    // Execute API call
    RESTRequest.Execute;

    if RESTResponse.StatusCode <> 200 then
    begin
        raise Exception.CreateFMT('Api request failed with status: %d - %s',
        [RESTResponse.StatusCode, RESTResponse.StatusText]);
    end;

    // Parse JSON response
    JSONArr := TJSONObject.ParseJSONValue(RESTResponse.Content).GetValue<TJSONArray>('results');

    if not Assigned(JSONArr) then
      raise Exception.Create('Invalid or empty response from the API');

    // Prepare TFDMemTable
    MovieList.Close;
    MovieList.FieldDefs.Clear;
    MovieList.FieldDefs.Add('id', ftInteger);
    MovieList.FieldDefs.Add('title', ftString, 255);
    MovieList.FieldDefs.Add('release_date', ftDate);
    MovieList.FieldDefs.Add('overview', ftMemo);
    MovieList.CreateDataSet;

    // Load data into TFDMemTable
    for i := 0 to JSONArr.Count - 1 do
    begin
      JSONObj := JSONArr.Items[i] as TJSONObject;
      MovieList.Append;
      MovieList.FieldByName('id').AsInteger := JSONObj.GetValue<Integer>('id');
      MovieList.FieldByName('title').AsString := JSONObj.GetValue<string>('title');

      ReleaseDateStr := JSONObj.GetValue<string>('release_date');
      if (ReleaseDateStr <> '') and TryISO8601ToDate(ReleaseDateStr, ReleaseDate) then
        MovieList.FieldByName('release_date').AsDateTime := ReleaseDate
      else
        MovieList.FieldByName('release_date').Clear;

      MovieList.FieldByName('overview').AsString := JSONObj.GetValue<string>('overview');
      MovieList.Post;
    end;

    MovieList.Open;

  finally
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
  end;
end;

end.

