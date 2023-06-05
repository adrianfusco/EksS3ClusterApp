import os
from flask import Flask, request, render_template, send_file
from concurrent import futures

from s3_operations import list_objects, download_file, create_zip_file

app = Flask(__name__)

BUCKET_NAME = 'thisisjustanexample'


@app.route('/')
def index():
    objects = list_objects(BUCKET_NAME)
    return render_template(
        'index.html',
        objects=objects,
        bucket_name=BUCKET_NAME
    )


@app.route('/download', methods=['POST'])
def download():
    selected_files = request.form.getlist('file')
    if not selected_files:
        return "No files selected. You should select at least one."

    file_paths = []
    with futures.ThreadPoolExecutor() as executor:
        download_tasks = {}
        for file in selected_files:
            task = executor.submit(download_file, BUCKET_NAME, file)
            download_tasks[task] = file

        for future in futures.as_completed(download_tasks):
            try:
                file = download_tasks[future]
                file_path = future.result()
                if not file_path:
                    return f"Failed to download file: {file}"
                file_paths.append(file_path)
            except Exception as e:
                return f"Error occurred while downloading files: {str(e)}"

    try:
        zip_file_path = create_zip_file(file_paths, BUCKET_NAME)
    except Exception as e:
        return f"Error occurred while creating zip file: {str(e)}"

    return send_file(
        zip_file_path,
        as_attachment=True,
        download_name=os.path.basename(zip_file_path)
    )


if __name__ == '__main__':
    app.run(port=5000)
