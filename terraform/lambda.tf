data "archive_file" "get_visitors_zip" {
    type = "zip"
    source_file = abspath("../src/${var.file_names.get}.py")
    output_path = abspath("../zip/${var.file_names.get}.zip")
}

data "archive_file" "add_visitors_zip" {
    type = "zip"
    source_file = abspath("../src/${var.file_names.add}.py")
    output_path = abspath("../zip/${var.file_names.add}.zip")
}

data "archive_file" "sub_visitors_zip" {
    type = "zip"
    source_file = abspath("../src/${var.file_names.sub}.py")
    output_path = abspath("../zip/${var.file_names.sub}.zip")
}

resource "aws_lambda_function" "get_lambda_func" {
    filename = data.archive_file.get_visitors_zip.output_path
    function_name = "Get_Visitors"
    role = aws_iam_role.lambda_role.arn
    handler = "get_visitors.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_iam_policy]
}

resource "aws_lambda_function" "add_lambda_func" {
    filename = data.archive_file.add_visitors_zip.output_path
    function_name = "Add_Visitors"
    role = aws_iam_role.lambda_role.arn
    handler = "add_visitors.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_iam_policy]
}

resource "aws_lambda_function" "sub_lambda_func" {
    filename = data.archive_file.sub_visitors_zip.output_path
    function_name = "Sub_Visitors"
    role = aws_iam_role.lambda_role.arn
    handler = "sub_visitors.lambda_handler"
    runtime = "python3.9"
    depends_on = [aws_iam_role_policy_attachment.attach_iam_policy]
}