namespace: jenkins.integration.flows

imports:
  ops: user.ops

flow:
  name: run_app

  inputs:
    - build_dir
    - db_host
    - db_host_user
    - db_host_password

  workflow:
    start_app:
      do:
        ops.run_jar:
          - jar_path: build_dir + "/target/spring-boot-sample-tomcat-1.2.0.RELEASE.jar"

    wait_for_app_to_start:
      do:
        ops.verify_app_is_up:
          - host: "'localhost'"
          - port: "'9002'"
          - max_seconds_to_wait: "'60'"

    test:
      do:
        ops.print:
          - text: "'Testing things'"

    kill_app:
      do:
        ops.send_shutdown:

    wait_for_up_to_shutdown:
      do:
        ops.wait_for_up_to_shutdown:
          - host: "'localhost'"
          - port: "'9002'"
          - max_seconds_to_wait: "'10'"

    check_db_is_up:
      do:
        ops.check_postgres_is_up:
          - host: db_host
          - username: db_host_user
          - password: db_host_password
