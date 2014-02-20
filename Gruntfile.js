module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-shell');
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        watch: {
            tests: {
                files: [
                    'test/**/*.dart',
                    'test/**/*.html',
                    'lib/**/*.dart',
                    'lib/**/*.html'
                ],
                tasks: ['shell:test'],
                options: {atBegin: true}
            }
        },
        shell: {
            test: {
                command: 'test/run.sh',
                options: {
                    stdout: true,
                    failOnError: true
                }
            }
        }
    });
};
