resource "aws_iam_instance_profile" "bastion_readonly" {
  name = "${var.global_name}-bastion-readonly"

  role = "${aws_iam_role.bastion_readonly.name}"
}

resource "aws_iam_role" "bastion_readonly" {
  name = "${var.global_name}-bastion-readonly-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "cloudtrail.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bastion_readonly_policy" {
  name = "${var.global_name}-bastion-readonly-policy"
  role = "${aws_iam_role.bastion_readonly.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1425916919000",
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:Get*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Stmt1452171476000",
            "Effect": "Allow",
            "Action": [
                "ec2:AssociateAddress",
                "ec2:Describe*",
                "autoscaling:Describe*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  role       = "${aws_iam_role.bastion_readonly.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
