from flask import Flask, request, jsonify, send_from_directory
import subprocess
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__)

# ── Serve frontend ────────────────────────────────────────────────────────────
@app.route("/")
def index():
    return send_from_directory(BASE_DIR, "index.html")

# ── Helper: run COBOL exe with optional stdin ─────────────────────────────────
def run_cobol(exe_name, stdin_input=None):
    exe_path = os.path.join(BASE_DIR, exe_name)
    if not os.path.exists(exe_path):
        return None, f"{exe_name} not found in {BASE_DIR}"
    try:
        result = subprocess.run(
            [exe_path],
            input=stdin_input,
            capture_output=True,
            text=True,
            timeout=10,
            cwd=BASE_DIR
        )
        stdout = result.stdout.strip()
        stderr = result.stderr.strip()
        print(f"[{exe_name}] returncode={result.returncode}")
        print(f"[{exe_name}] stdout={repr(stdout)}")
        print(f"[{exe_name}] stderr={repr(stderr)}")
        output = stdout if stdout else stderr
        return output, stderr
    except subprocess.TimeoutExpired:
        return None, f"{exe_name} timed out"
    except Exception as e:
        return None, str(e)

# ── API 1: Add ONE expense at a time via stdin → add-expense.exe ─────────────
# COBOL uses OPEN EXTEND so each call appends one record
@app.route("/api/add", methods=["POST"])
def add_expenses():
    data = request.get_json()
    expenses = data.get("expenses", [])
    if not expenses:
        return jsonify({"error": "No expenses provided"}), 400

    results = []
    for exp in expenses:
        date   = str(exp.get("date", "")).strip()         # PIC X(10)
        amount = str(exp.get("amount", "0")).strip()      # PIC 9(6)
        desc   = str(exp.get("description", "")).strip()  # PIC X(30)

        # Pipe exactly as COBOL ACCEPT expects — one value per line
        stdin_input = f"{date}\n{amount}\n{desc}\n"
        print(f"[add-expenses] stdin={repr(stdin_input)}")

        out, err = run_cobol("add-expense.exe", stdin_input)
        if out is None:
            return jsonify({"error": f"Failed on expense '{desc}': {err}"}), 500
        results.append(out)

    return jsonify({
        "output": "\n".join(results),
        "status": f"{len(expenses)} expense(s) recorded successfully!"
    })

# ── API 2: View total → view-total.exe ───────────────────────────────────────
@app.route("/api/total", methods=["GET"])
def view_total():
    out, err = run_cobol("view-total.exe")
    if out is None:
        return jsonify({"error": err}), 500
    return jsonify({"output": out, "stderr": err})

# ── API 3: View records → view-records.exe ───────────────────────────────────
@app.route("/api/records", methods=["GET"])
def view_records():
    out, err = run_cobol("view-records.exe")
    if out is None:
        return jsonify({"error": err}), 500
    return jsonify({"output": out, "stderr": err})

# ── API 4: Clear expenses.dat ─────────────────────────────────────────────────
@app.route("/api/clear", methods=["POST"])
def clear_expenses():
    dat_path = os.path.join(BASE_DIR, "expenses.dat")
    try:
        open(dat_path, "w").close()
        return jsonify({"status": "expenses.dat cleared"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ── API 5: Debug ──────────────────────────────────────────────────────────────
@app.route("/api/debug")
def debug():
    dat_path = os.path.join(BASE_DIR, "expenses.dat")
    dat_exists = os.path.exists(dat_path)
    dat_content = ""
    if dat_exists:
        with open(dat_path, "r") as f:
            dat_content = f.read()
    return jsonify({
        "base_dir": BASE_DIR,
        "dat_exists": dat_exists,
        "dat_content": dat_content,
        "add_expenses_exists": os.path.exists(os.path.join(BASE_DIR, "add-expense.exe")),
        "view_total_exists":   os.path.exists(os.path.join(BASE_DIR, "view-total.exe")),
        "view_records_exists": os.path.exists(os.path.join(BASE_DIR, "view-records.exe")),
    })

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(debug=False, host="0.0.0.0", port=port)

