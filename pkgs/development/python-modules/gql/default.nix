{ lib
, aiofiles
, aiohttp
, anyio
, backoff
, botocore
, buildPythonPackage
, fetchFromGitHub
, graphql-core
, httpx
, mock
, parse
, pytest-asyncio
, pytest-console-scripts
, pytestCheckHook
, pythonOlder
, requests
, requests-toolbelt
, setuptools
, urllib3
, vcrpy
, websockets
, yarl
}:

buildPythonPackage rec {
  pname = "gql";
  version = "3.6.0b0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "gql";
    rev = "refs/tags/v${version}";
    hash = "sha256-yX6NbtGxBa3lL/bS3j2ouTPku6a4obqNGx1xRzx+Skk=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    anyio
    backoff
    graphql-core
    yarl
  ];

  nativeCheckInputs = [
    aiofiles
    mock
    parse
    pytest-asyncio
    pytest-console-scripts
    pytestCheckHook
    vcrpy
  ] ++ passthru.optional-dependencies.all;

  passthru.optional-dependencies = {
    all = [
      aiohttp
      botocore
      httpx
      requests
      requests-toolbelt
      urllib3
      websockets
    ];
    aiohttp = [
      aiohttp
    ];
    httpx = [
      httpx
    ];
    requests = [
      requests
      requests-toolbelt
      urllib3
    ];
    websockets = [
      websockets
    ];
    botocore = [
      botocore
    ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  disabledTests = [
    # Tests requires network access
    "test_execute_result_error"
    "test_http_transport"
  ];

  disabledTestPaths = [
    # Exclude linter tests
    "gql-checker/tests/test_flake8_linter.py"
    "gql-checker/tests/test_pylama_linter.py"
    # Tests require network access
    "tests/custom_scalars/test_money.py"
    "tests/test_aiohttp.py"
    "tests/test_appsync_http.py"
    "tests/test_appsync_websockets.py"
    "tests/test_async_client_validation.py"
    "tests/test_graphqlws_exceptions.py"
    "tests/test_graphqlws_subscription.py"
    "tests/test_phoenix_channel_exceptions.py"
    "tests/test_phoenix_channel_exceptions.py"
    "tests/test_phoenix_channel_query.py"
    "tests/test_phoenix_channel_subscription.py"
    "tests/test_requests.py"
    "tests/test_websocket_exceptions.py"
    "tests/test_websocket_query.py"
    "tests/test_websocket_subscription.py"
  ];

  pythonImportsCheck = [
    "gql"
  ];

  meta = with lib; {
    description = "GraphQL client in Python";
    homepage = "https://github.com/graphql-python/gql";
    changelog = "https://github.com/graphql-python/gql/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
