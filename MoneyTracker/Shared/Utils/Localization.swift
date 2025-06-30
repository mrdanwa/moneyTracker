//Localization.swift
//String extensions for localization
//extension String

import SwiftUI
import CoreData

// MARK: - Localization Helpers
extension String {
    func l(_ lang: String) -> String {
        let dictionary: [String: [String: String]] = [
            // MARK: - Tabs
            "Overview": [
                "English": "Overview",
                "Spanish": "Resumen",
                "Chinese": "概括"
            ],
            "Stats": [
                "English": "Stats",
                "Spanish": "Estadísticas",
                "Chinese": "统计"
            ],
            "Settings": [
                "English": "Settings",
                "Spanish": "Configuraciones",
                "Chinese": "设置"
            ],
            // MARK: - General UI
            "No transactions for this month": [
                "English": "No transactions for this month",
                "Spanish": "No hay transacciones este mes",
                "Chinese": "本月没有交易"
            ],
            "No transactions for this year": [
                "English": "No transactions for this year",
                "Spanish": "No hay transacciones este año",
                "Chinese": "今年没有交易"
            ],
            "No expenses for this month": [
                "English": "No expenses for this month",
                "Spanish": "No hay gastos este mes",
                "Chinese": "本月没有支出"
            ],
            "No expenses for this year": [
                "English": "No expenses for this year",
                "Spanish": "No hay gastos este año",
                "Chinese": "今年没有支出"
            ],
            "No incomes for this month": [
                "English": "No incomes for this month",
                "Spanish": "No hay ingresos este mes",
                "Chinese": "本月没有收入"
            ],
            "No incomes for this year": [
                "English": "No incomes for this year",
                "Spanish": "No hay ingresos este año",
                "Chinese": "今年没有收入"
            ],
            "Add Transaction": [
                "English": "Add Transaction",
                "Spanish": "Añadir Transacción",
                "Chinese": "添加交易"
            ],
            "Search": [
                "English": "Search",
                "Spanish": "Buscar",
                "Chinese": "搜索"
            ],
            "New Transaction": [
                "English": "New Transaction",
                "Spanish": "Nueva Transacción",
                "Chinese": "新交易"
            ],
            "Edit Transaction": [
                "English": "Edit Transaction",
                "Spanish": "Editar Transacción",
                "Chinese": "编辑交易"
            ],
            "Update": [
                "English": "Update",
                "Spanish": "Actualizar",
                "Chinese": "更新"
            ],
            "Delete Transaction": [
                "English": "Delete Transaction",
                "Spanish": "Eliminar Transacción",
                "Chinese": "删除交易"
            ],
            "Delete": [
                "English": "Delete",
                "Spanish": "Eliminar",
                "Chinese": "删除"
            ],
            "Cancel": [
                "English": "Cancel",
                "Spanish": "Cancelar",
                "Chinese": "取消"
            ],
            "Accept": [
                "English": "Accept",
                "Spanish": "Aceptar",
                "Chinese": "确定"
            ],
            "Are you sure you want to delete this transaction? This action cannot be undone.": [
                "English": "Are you sure you want to delete this transaction? This action cannot be undone.",
                "Spanish": "¿Está seguro de que desea eliminar esta transacción? Esta acción no se puede deshacer.",
                "Chinese": "您确定要删除此交易吗？此操作无法撤销。"
            ],
            // MARK: - Summary, Cards, and Stats
            "Income": [
                "English": "Income",
                "Spanish": "Ingreso",
                "Chinese": "收入"
            ],
            "Expenses": [
                "English": "Expenses",
                "Spanish": "Gastos",
                "Chinese": "支出"
            ],
            "Balance": [
                "English": "Balance",
                "Spanish": "Balance",
                "Chinese": "余额"
            ],
            "Expense": [
                "English": "Expense",
                "Spanish": "Gasto",
                "Chinese": "支出"
            ],
            "No matching transactions found": [
                "English": "No matching transactions found",
                "Spanish": "No se encontraron transacciones",
                "Chinese": "未找到匹配交易"
            ],
            "Try adjusting your search or date range": [
                "English": "Try adjusting your search or date range",
                "Spanish": "Intenta ajustar tu búsqueda o rango de fechas",
                "Chinese": "尝试调整搜索或日期范围"
            ],
            // MARK: - Search
            "Search by category or note": [
                "English": "Search by category or note",
                "Spanish": "Buscar por categoría o nota",
                "Chinese": "按类别或备注搜索"
            ],
            "Search Transactions": [
                "English": "Search Transactions",
                "Spanish": "Buscar Transacciones",
                "Chinese": "搜索交易"
            ],
            // MARK: - Settings
            "Currency": [
                "English": "Currency",
                "Spanish": "Moneda",
                "Chinese": "货币"
            ],
            "Language": [
                "English": "Language",
                "Spanish": "Idioma",
                "Chinese": "语言"
            ],
            "Appearance": [
                "English": "Appearance",
                "Spanish": "Apariencia",
                "Chinese": "外观"
            ],
            "Dark Mode": [
                "English": "Dark Mode",
                "Spanish": "Modo Oscuro",
                "Chinese": "深色模式"
            ],
            // MARK: - Language Names
            "English": [
                "English": "English",
                "Spanish": "Inglés",
                "Chinese": "英语"
            ],
            "Spanish": [
                "English": "Spanish",
                "Spanish": "Español",
                "Chinese": "西班牙语"
            ],
            "Chinese": [
                "English": "Chinese",
                "Spanish": "Chino",
                "Chinese": "中文"
            ],
            // MARK: - Date Range
            "From": [
                "English": "From",
                "Spanish": "Desde",
                "Chinese": "从"
            ],
            "To": [
                "English": "To",
                "Spanish": "Hasta",
                "Chinese": "到"
            ],
            // MARK: - Transaction Fields
            "Transaction Type": [
                "English": "Transaction Type",
                "Spanish": "Tipo de Transacción",
                "Chinese": "交易类型"
            ],
            "Details": [
                "English": "Details",
                "Spanish": "Detalles",
                "Chinese": "详情"
            ],
            "Category": [
                "English": "Category",
                "Spanish": "Categoría",
                "Chinese": "类别"
            ],
            "Amount": [
                "English": "Amount",
                "Spanish": "Cantidad",
                "Chinese": "金额"
            ],
            "Date": [
                "English": "Date",
                "Spanish": "Fecha",
                "Chinese": "日期"
            ],
            "Note": [
                "English": "Note",
                "Spanish": "Nota",
                "Chinese": "备注"
            ],
            "Save Transaction": [
                "English": "Save Transaction",
                "Spanish": "Guardar Transacción",
                "Chinese": "保存交易"
            ],
            "Select Category": [
                "English": "Select Category",
                "Spanish": "Seleccionar Categoría",
                "Chinese": "选择类别"
            ],
            // MARK: - Category Names
            "Allowance": [
                "English": "Allowance",
                "Spanish": "Préstamo",
                "Chinese": "贷款"
            ],
            "Bonus": [
                "English": "Bonus",
                "Spanish": "Bono",
                "Chinese": "奖金"
            ],
            "Business": [
                "English": "Business",
                "Spanish": "Negocios",
                "Chinese": "商业"
            ],
            "Investment": [
                "English": "Investment",
                "Spanish": "Inversión",
                "Chinese": "投资"
            ],
            "Other": [
                "English": "Other",
                "Spanish": "Otro",
                "Chinese": "其他"
            ],
            "Salary": [
                "English": "Salary",
                "Spanish": "Salario",
                "Chinese": "工资"
            ],
            "Car": [
                "English": "Car",
                "Spanish": "Coche",
                "Chinese": "汽车"
            ],
            "Clothing": [
                "English": "Clothing",
                "Spanish": "Ropa",
                "Chinese": "服装"
            ],
            "Food": [
                "English": "Food",
                "Spanish": "Comida",
                "Chinese": "食品"
            ],
            "Health": [
                "English": "Health",
                "Spanish": "Salud",
                "Chinese": "健康"
            ],
            "Household": [
                "English": "Household",
                "Spanish": "Hogar",
                "Chinese": "家庭"
            ],
            "Social": [
                "English": "Social",
                "Spanish": "Social",
                "Chinese": "社交"
            ],
            "Supermarket": [
                "English": "Supermarket",
                "Spanish": "Supermercado",
                "Chinese": "超市"
            ],
            "Taxes": [
                "English": "Taxes",
                "Spanish": "Impuestos",
                "Chinese": "税收"
            ],
            "Transportation": [
                "English": "Transportation",
                "Spanish": "Transporte",
                "Chinese": "交通"
            ],
            "Travel": [
                "English": "Travel",
                "Spanish": "Viaje",
                "Chinese": "旅行"
            ],
            "Shopping": [
                "English": "Shopping",
                "Spanish": "Compras",
                "Chinese": "购物"
            ],
            // MARK: - Account
            "Edit Account": [
                "English": "Edit Account",
                "Spanish": "Editar cuenta",
                "Chinese": "编辑账户"
            ],
            "New Account": [
                "English": "New Account",
                "Spanish": "Nueva cuenta",
                "Chinese": "新账户"
            ],
            "Account Name": [
                "English": "Account Name",
                "Spanish": "Nombre de la cuenta",
                "Chinese": "账户名称"
            ],
            "Accounts": [
                "English": "Accounts",
                "Spanish": "Cuentas",
                "Chinese": "账户"
            ],
            "Restore": [
                "English": "Restore",
                "Spanish": "Restaurar",
                "Chinese": "恢复"
            ],
            "Restore Main Account": [
                "English": "Restore Main Account",
                "Spanish": "Restaurar cuenta principal",
                "Chinese": "恢复主账户"
            ],
            "Are you sure you want to delete all transactions for this account? This action cannot be undone.": [
                "English": "Are you sure you want to delete all transactions for this account? This action cannot be undone.",
                "Spanish": "¿Estás seguro de que quieres eliminar todas las transacciones de esta cuenta? Esta acción no se puede deshacer.",
                "Chinese": "您确定要删除此账户的所有交易吗？此操作无法撤销。"
            ],
            // MARK: - Backup
            "Backup": [
                "English": "Backup",
                "Spanish": "Copia de seguridad",
                "Chinese": "备份"
            ],
            "Export CSV": [
                "English": "Export CSV",
                "Spanish": "Exportar CSV",
                "Chinese": "导出 CSV"
            ],
            "Import CSV": [
                "English": "Import CSV",
                "Spanish": "Importar CSV",
                "Chinese": "导入 CSV"
            ],
            "CSV Format Requirements": [
                "English": "CSV Format Requirements",
                "Spanish": "Requisitos de formato CSV",
                "Chinese": "CSV 格式要求"
            ],
            "Continue": [
                "English": "Continue",
                "Spanish": "Continuar",
                "Chinese": "继续"
            ],
            "Import Error": [
                "English": "Import Error",
                "Spanish": "Error de importación",
                "Chinese": "导入错误"
            ],
            "OK": [
                "English": "OK",
                "Spanish": "Aceptar",
                "Chinese": "确定"
            ],
            "EmptyFileError": [
                "English": "The CSV file is empty",
                "Spanish": "El archivo CSV está vacío",
                "Chinese": "CSV文件为空"
            ],
            "InvalidHeadersError" : [
                "English": "Invalid CSV headers.\nExpected: %@\nFound: %@",
                "Spanish": "Encabezados CSV no válidos.\nEsperado: %@\nEncontrado: %@",
                "Chinese": "CSV标题无效。\n预期: %@\n实际: %@"
            ],
            "Requirements": [
                "English":  """
                            CSV Format Requirements:
                            
                            Headers (in order):
                            Account, Type, Category, Amount, Currency, Date, Note
                            
                            Content Format:
                            - Account: Account name (text)
                            - Type: 'income' or 'expense'
                            - Category: Valid category name
                            - Amount: Decimal number
                            - Currency: Valid currency code (USD, EUR, etc.)
                            - Date: YYYY-MM-DD format
                            - Note: Text (commas should be converted to semicolons)
                            
                            Example:
                            Account,Type,Category,Amount,Currency,Date,Note
                            Savings,income,Salary,5000.00,USD,2024-02-07,Monthly salary
                            """,
                "Spanish":  """
                            Requisitos de formato CSV:
                            
                            Encabezados (en orden):
                            Account, Type, Category, Amount, Currency, Date, Note
                            
                            Formato del contenido:
                            - Account: Nombre de la cuenta (texto)
                            - Type: 'income' o 'expense'
                            - Category: Nombre de una categoría válida
                            - Amount: Número decimal
                            - Currency: Código de moneda válido (USD, EUR, etc.)
                            - Date: Formato YYYY-MM-DD
                            - Note: Texto (las comas deben convertirse en puntos y coma)
                            
                            Ejemplo:
                            Account,Type,Category,Amount,Currency,Date,Note
                            Ahorros,income,Salary,5000.00,USD,2024-02-07,Salario mensual
                            """,
                "Chinese":  """
                            CSV 格式要求:
                            
                            标题（按顺序）:
                            Account, Type, Category, Amount, Currency, Date, Note
                            
                            内容格式:
                            - Account: 账户名称（文本）
                            - Type: 'income' 或 'expense'
                            - Category: 有效的类别名称
                            - Amount: 十进制数
                            - Currency: 有效的货币代码（USD, EUR 等）
                            - Date: YYYY-MM-DD 格式
                            - Note: 文本（逗号应转换为分号）
                            
                            示例:
                            Account,Type,Category,Amount,Currency,Date,Note
                            储蓄,income,Salary,5000.00,USD,2024-02-07,每月工资
                            """
            ]
            
        ]
        
        // Return the localized string if found, otherwise fallback to the original string.
        if let translations = dictionary[self],
           let localized = translations[lang] {
            return localized
        } else {
            return self
        }
    }
}

/// Helper function to localize category names (stored in English) for display.
func localizedCategory(_ englishName: String, language: String) -> String {
    return englishName.l(language)
}
