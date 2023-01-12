resource "aws_api_gateway_rest_api" "resume_api" {
    name = "ResumeAPI"
    description = "Backend API to the Resume App"
}


# get_visitors

resource "aws_api_gateway_resource" "proxy_get" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    parent_id = aws_api_gateway_rest_api.resume_api.root_resource_id
    path_part = var.file_names.get
}

resource "aws_api_gateway_method" "proxy_get" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    resource_id = aws_api_gateway_resource.proxy_get.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_lambda" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    resource_id = aws_api_gateway_method.proxy_get.resource_id
    http_method = aws_api_gateway_method.proxy_get.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.get_lambda_func.invoke_arn
}

resource "aws_lambda_permission" "apigw-get" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.get_lambda_func.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.resume_api.execution_arn}/*/*"
}


# add_visitors

resource "aws_api_gateway_resource" "proxy_add" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    parent_id = aws_api_gateway_rest_api.resume_api.root_resource_id
    path_part = var.file_names.add
}

resource "aws_api_gateway_method" "proxy_add" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    resource_id = aws_api_gateway_resource.proxy_add.id
    http_method = "PATCH"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "add_lambda" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    resource_id = aws_api_gateway_method.proxy_add.resource_id
    http_method = aws_api_gateway_method.proxy_add.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.add_lambda_func.invoke_arn
}

resource "aws_lambda_permission" "apigw-add" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.add_lambda_func.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.resume_api.execution_arn}/*/*"
}


# sub_visitors

resource "aws_api_gateway_resource" "proxy_sub" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    parent_id = aws_api_gateway_rest_api.resume_api.root_resource_id
    path_part = var.file_names.sub
}

resource "aws_api_gateway_method" "proxy_sub" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    resource_id = aws_api_gateway_resource.proxy_sub.id
    http_method = "PATCH"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "sub_lambda" {
    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    resource_id = aws_api_gateway_method.proxy_sub.resource_id
    http_method = aws_api_gateway_method.proxy_sub.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.sub_lambda_func.invoke_arn
}

resource "aws_lambda_permission" "apigw-sub" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.sub_lambda_func.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.resume_api.execution_arn}/*/*"
}


resource "aws_api_gateway_deployment" "deploy" {
    depends_on = [
      aws_api_gateway_integration.add_lambda,
      aws_api_gateway_integration.get_lambda,
      aws_api_gateway_integration.sub_lambda
    ]

    rest_api_id = aws_api_gateway_rest_api.resume_api.id
    stage_name = "v1"
}

output "api_url" {
    value = aws_api_gateway_deployment.deploy.invoke_url
}